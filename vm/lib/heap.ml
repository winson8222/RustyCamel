type node_tag =
  | False_tag
  | True_tag
  | Number_tag
  | String_tag
  | Null_tag
  | Unassigned_tag
  | Undefined_tag
  | Blockframe_tag
  | Callframe_tag
  | Closure_tag
  | Frame_tag
  | Environment_tag
  | Pair_tag
  | Builtin_tag
[@@deriving enum]

type config = {
  heap_size_words : int;
  word_size : int;
  tag_offset : int;
  size_offset : int;
}

type canonical_values = {
  unassigned_addr : int;
  undefined_addr : int;
  false_addr : int;
  true_addr : int;
}

type t = {
  config : config;
  buffer : Buffer.t;
  free : int ref;
  env_addr : int ref;
  mutable canonical_values : canonical_values;
}

let heap_size_words = 300
let to_space = heap_size_words / 2

let initial_config =
  { heap_size_words; word_size = 8; tag_offset = 0; size_offset = 2 }

(* Exported functions *)

let heap_get_word state address =
  let addr_byte = address * state.config.word_size in
  Buffer.get_float64_at_offset state.buffer addr_byte

let heap_set_word state ~address ~word =
  let addr_byte = address * state.config.word_size in
  Buffer.set_float64_at_offset state.buffer addr_byte word

let heap_get_child state ~address ~child_index =
  heap_get_word state (address + 1 + child_index)

let heap_get_child_as_int state ~address ~child_index =
  Float.to_int (heap_get_child state ~address ~child_index)

let heap_set_child state ~address ~child_index ~value =
  heap_set_word state ~address:(address + 1 + child_index) ~word:value

let heap_get_tag state address =
  let addr_byte = address * state.config.word_size in
  let tag_number =
    Buffer.get_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset)
  in
  match node_tag_of_enum tag_number with
  | Some tag -> tag
  | None -> failwith "Unrecognized tag"

let heap_get_size state address =
  let addr_byte = address * state.config.word_size in
  Buffer.get_uint16_at_offset state.buffer (addr_byte + state.config.size_offset)

let heap_get_num_children state addr =
  let tag = heap_get_tag state addr in
  match tag with Number_tag -> 0 | _ -> heap_get_size state addr - 1

let heap_set_tag state address tag =
  let addr_byte = address * state.config.word_size in
  let tag_number = node_tag_to_enum tag in
  Buffer.set_uint8_at_offset state.buffer
    (addr_byte + state.config.tag_offset)
    tag_number

let heap_set_size state address size =
  let addr_byte = address * state.config.word_size in
  Buffer.set_uint16_at_offset state.buffer
    (addr_byte + state.config.size_offset)
    size

let debug_print_bytes state byte_addr count =
  Printf.printf "Memory at %d (byte addr %d):\n" byte_addr
    (byte_addr * state.config.word_size);
  for i = 0 to count - 1 do
    Printf.printf "%02x "
      (Buffer.get_uint8_at_offset state.buffer
         ((byte_addr * state.config.word_size) + i));
    if (i + 1) mod 8 = 0 then Printf.printf "\n"
  done;
  Printf.printf "\n"

let heap_allocate state ~size ~tag =
  if !(state.free) = -1 then failwith "Heap ran out of memory"
  else
    let addr = !(state.free) in
    heap_set_tag state addr tag;
    heap_set_size state addr size;
    state.free := Float.to_int (heap_get_word state addr);
    addr

let heap_allocate_canonical_values : t -> unit =
 fun state ->
  let unassigned_addr = heap_allocate state ~size:1 ~tag:Unassigned_tag in
  let undefined_addr = heap_allocate state ~size:1 ~tag:Undefined_tag in
  let false_addr = heap_allocate state ~size:1 ~tag:False_tag in
  let true_addr = heap_allocate state ~size:1 ~tag:True_tag in
  state.canonical_values <-
    { unassigned_addr; undefined_addr; true_addr; false_addr }

let callframe_pc_offset = 2

let heap_set_two_bytes_in_word_at_offset state ~addr ~offset ~value =
  let buffer_offset = (addr * state.config.word_size) + offset in
  Buffer.set_uint16_at_offset state.buffer buffer_offset value

let heap_get_two_bytes_in_word_at_offset state ~addr ~offset =
  let buffer_offset = (addr * state.config.word_size) + offset in
  Buffer.get_uint16_at_offset state.buffer buffer_offset

let heap_allocate_callframe state ~pc ~env_addr =
  let addr = heap_allocate state ~size:2 ~tag:Callframe_tag in
  heap_set_two_bytes_in_word_at_offset state ~addr ~offset:callframe_pc_offset
    ~value:pc;
  heap_set_child state ~address:addr ~child_index:0
    ~value:(Float.of_int env_addr);
  addr

let create =
  let rec set_free_pointers state prev_addr cur_addr =
    if cur_addr >= heap_size_words then () (* Base case: reached end of heap *)
    else (
      heap_set_word state ~address:prev_addr ~word:(Float.of_int cur_addr);
      set_free_pointers state cur_addr (cur_addr + state.config.word_size))
  in
  let state =
    {
      config = initial_config;
      buffer =
        Buffer.create (initial_config.heap_size_words * initial_config.word_size);
      free = ref to_space;
      env_addr = ref 0;
      canonical_values =
        {
          unassigned_addr = 0;
          undefined_addr = 0;
          true_addr = 0;
          false_addr = 0;
        };
    }
  in
  heap_allocate_canonical_values state;
  set_free_pointers state 0 initial_config.word_size;
  state

(* One child : Blockframe address *)
let heap_allocate_blockframe state ~env_addr =
  let blockframe_addr = heap_allocate state ~size:2 ~tag:Blockframe_tag in
  heap_set_child state ~address:blockframe_addr ~child_index:0
    ~value:(Float.of_int env_addr);
  blockframe_addr

let heap_allocate_environment state ~num_frames =
  heap_allocate state ~size:(num_frames + 1) ~tag:Environment_tag

let heap_set_env_val_addr_at_pos state ~env_addr ~frame_index ~val_index
    ~val_addr =
  let frame_addr =
    heap_get_child_as_int state ~address:env_addr ~child_index:frame_index
  in
  ignore
    (heap_set_child state ~address:frame_addr ~child_index:val_index
       ~value:(Float.of_int val_addr))

let heap_get_env_val_addr_at_pos state ~env_addr ~frame_index ~val_index =
  let frame_addr =
    heap_get_child_as_int state ~address:env_addr ~child_index:frame_index
  in
  Float.to_int (heap_get_child state ~address:frame_addr ~child_index:val_index)

let helper_copy_env_frames state ~old_env_addr ~new_env_addr =
  let num_children = heap_get_num_children state old_env_addr in
  let rec helper_copy_env_frames child_index =
    if child_index >= num_children then ()
    else
      let child_node =
        heap_get_child state ~address:old_env_addr ~child_index
      in
      heap_set_child state ~address:new_env_addr ~child_index ~value:child_node;
      helper_copy_env_frames (child_index + 1)
  in
  helper_copy_env_frames 0

let heap_env_extend state ~new_frame_addr =
  let env_addr = !(state.env_addr) in
  let old_num_frames = heap_get_size state env_addr in
  let new_env_addr =
    heap_allocate_environment state ~num_frames:(old_num_frames + 1)
  in
  helper_copy_env_frames state ~old_env_addr:env_addr ~new_env_addr;
  heap_set_child state ~address:new_env_addr ~child_index:old_num_frames
    ~value:(Float.of_int new_frame_addr);
  new_env_addr

let heap_set_frame_children_to_unassigned state ~frame_addr ~num_children =
  let rec helper cur_child_index =
    if cur_child_index >= num_children then ()
    else (
      heap_set_child state ~address:frame_addr ~child_index:cur_child_index
        ~value:(Float.of_int state.canonical_values.unassigned_addr);
      helper (cur_child_index + 1))
  in
  helper 0

let heap_get_blockframe_env state addr =
  Float.to_int (heap_get_child state ~address:addr ~child_index:0)

(* Values *)
let heap_allocate_number state number =
  let addr = heap_allocate state ~size:2 ~tag:Number_tag in
  heap_set_word state ~address:(addr + 1) ~word:number;
  addr

let heap_allocate_string state str =
  let len_string = String.length str in
  let addr = heap_allocate state ~size:(len_string + 1) ~tag:String_tag in
  let rec helper_set_char char_index =
    if char_index >= len_string then ()
    else
      let char_val = Float.of_int (Char.code (String.get str char_index)) in
      heap_set_child state ~address:addr ~child_index:char_index ~value:char_val;
      helper_set_char (char_index + 1)
  in
  helper_set_char 0;
  addr

let heap_allocate_value state lit_value =
  match lit_value with
  | Value.Int i -> heap_allocate_number state (Float.of_int i)
  | String s -> heap_allocate_string state s
  | Boolean b -> (
      match b with
      | true -> state.canonical_values.true_addr
      | false -> state.canonical_values.false_addr)
  | Undefined -> state.canonical_values.undefined_addr

let heap_get_number_value state addr = heap_get_word state (addr + 1)

let heap_get_string_value state addr =
  let num_chars = heap_get_num_children state addr in
  let rec helper cur_index =
    if cur_index >= num_chars then ""
    else
      let char =
        heap_get_child state ~address:addr ~child_index:cur_index
        |> Float.to_int |> Char.chr
      in
      String.make 1 char ^ helper (cur_index + 1)
  in
  helper 0

let is_callframe state addr =
  let tag = heap_get_tag state addr in
  match tag with Callframe_tag -> true | _ -> false

let heap_get_callframe_pc state addr =
  let pc =
    heap_get_two_bytes_in_word_at_offset state ~addr ~offset:callframe_pc_offset
  in
  pc

let heap_get_callframe_env state addr =
  let env_addr = heap_get_child state ~address:addr ~child_index:0 in
  Float.to_int env_addr
