open LRUCache
module StringLRU = Make (String)

type node_tag =
  | Unassigned_tag
  | False_tag
  | True_tag
  | Number_tag
  | String_tag
  | Ref_tag
  | Null_tag
  | Undefined_tag
  | Blockframe_tag
  | Callframe_tag
  | Closure_tag
  | Frame_tag
  | Environment_tag
  | Pair_tag
  | Builtin_tag
[@@deriving enum]

let string_of_node_tag = function
  | Unassigned_tag -> "Unassigned_tag"
  | False_tag -> "False_tag"
  | True_tag -> "True_tag"
  | Number_tag -> "Number_tag"
  | String_tag -> "String_tag"
  | Ref_tag -> "Ref_tag"
  | Null_tag -> "Null_tag"
  | Undefined_tag -> "Undefined_tag"
  | Blockframe_tag -> "Blockframe_tag"
  | Callframe_tag -> "Callframe_tag"
  | Closure_tag -> "Closure_tag"
  | Frame_tag -> "Frame_tag"
  | Environment_tag -> "Environment_tag"
  | Pair_tag -> "Pair_tag"
  | Builtin_tag -> "Builtin_tag"

type config = {
  heap_size_words : int;
  node_size : int;
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
  mutable canonical_values : canonical_values option;
  string_intern_table : int StringLRU.t;
}

let heap_size_words = 5000

let initial_config =
  {
    heap_size_words;
    word_size = 8;
    tag_offset = 0;
    size_offset = 2;
    node_size = 10;
  }

(* Exported functions *)

let heap_get state address =
  let addr_byte = address * state.config.word_size in
  Buffer.get_float64_at_offset state.buffer addr_byte

let heap_set state ~address ~word =
  let addr_byte = address * state.config.word_size in
  Buffer.set_float64_at_offset state.buffer addr_byte word

let heap_get_child state ~address ~child_index =
  heap_get state (address + 1 + child_index)

let heap_get_child_as_int state ~address ~child_index =
  Float.to_int (heap_get_child state ~address ~child_index)

let heap_set_child state ~address ~child_index ~value =
  heap_set state ~address:(address + 1 + child_index) ~word:value

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
  if size > state.config.node_size then
    failwith
      ("Node size must be less than equal "
      ^ Int.to_string state.config.node_size)
  else if !(state.free) = -1 then failwith "Heap ran out of memory"
  else
    let addr = !(state.free) in
    Printf.printf "Allocated address: %d\n" addr;
    heap_set_tag state addr tag;
    heap_set_size state addr size;
    state.free := Float.to_int (heap_get state addr);
    addr

let heap_allocate_canonical_values state =
  let unassigned_addr = heap_allocate state ~size:1 ~tag:Unassigned_tag in
  let undefined_addr = heap_allocate state ~size:1 ~tag:Undefined_tag in
  let false_addr = heap_allocate state ~size:1 ~tag:False_tag in
  let true_addr = heap_allocate state ~size:1 ~tag:True_tag in
  state.canonical_values <-
    Some { unassigned_addr; undefined_addr; true_addr; false_addr }

let callframe_pc_offset = 2

let heap_set_two_bytes_in_word_at_offset state ~addr ~offset ~value =
  let buffer_offset = (addr * state.config.word_size) + offset in
  Buffer.set_uint16_at_offset state.buffer buffer_offset value

let heap_get_two_bytes_in_word_at_offset state ~addr ~offset =
  let buffer_offset = (addr * state.config.word_size) + offset in
  Buffer.get_uint16_at_offset state.buffer buffer_offset

let heap_allocate_callframe state ~pc ~env_addr =
  let addr = heap_allocate state ~size:2 ~tag:Callframe_tag in
  (* print the size of the callframe *)
  heap_set_two_bytes_in_word_at_offset state ~addr ~offset:callframe_pc_offset
    ~value:pc;

  heap_set_child state ~address:addr ~child_index:0
    ~value:(Float.of_int env_addr);

  addr

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
  Printf.printf "Setting value at frame %d, position %d to address %d\n"
    frame_addr val_index val_addr;
  Printf.printf "Setting value at frame %d, position %d to address %d\n"
    frame_addr val_index val_addr;
  (* Set the value at the specified index in the frame *)
  ignore
    (heap_set_child state ~address:frame_addr ~child_index:val_index
       ~value:(Float.of_int val_addr))

let heap_get_env_val_addr_at_pos state ~env_addr ~frame_index ~val_index =
  let frame_addr =
    heap_get_child_as_int state ~address:env_addr ~child_index:frame_index
  in
  Float.to_int (heap_get_child state ~address:frame_addr ~child_index:val_index)

let heap_env_extend state ~new_frame_addr ~env_addr =
  (* 1. Allocate space for the new environment frame *)
  let old_size = heap_get_size state env_addr in
  let new_env_addr = heap_allocate_environment state ~num_frames:old_size in
  (* copy over old frames*)
  let rec helper_copy_env_frames cur_state child_index =
    if child_index >= old_size then ()
    else
      let child_node =
        heap_get_child cur_state ~address:env_addr ~child_index
      in

      heap_set_child cur_state ~address:new_env_addr ~child_index
        ~value:child_node;
      helper_copy_env_frames cur_state (child_index + 1)
  in
  helper_copy_env_frames state 0;

  heap_set_child state ~address:new_env_addr ~child_index:(old_size - 1)
    ~value:(Float.of_int new_frame_addr);
  new_env_addr

let get_canonical_values state =
  match state.canonical_values with
  | Some values -> values
  | None -> failwith "Canonical values not initialized"

let heap_set_frame_children_to_unassigned state ~frame_addr ~num_children =
  let rec helper cur_state cur_child_index =
    if cur_child_index >= num_children then ()
    else (
      heap_set_child cur_state ~address:frame_addr ~child_index:cur_child_index
        ~value:(Float.of_int (get_canonical_values state).unassigned_addr);
      helper cur_state (cur_child_index + 1))
  in
  helper state 0

let heap_get_blockframe_env state addr =
  Float.to_int (heap_get_child state ~address:addr ~child_index:0)

(* Values *)
let heap_allocate_number state number =
  let addr = heap_allocate state ~size:2 ~tag:Number_tag in
  heap_set state ~address:(addr + 1) ~word:number;
  addr

let heap_allocate_string state str =
  match StringLRU.find state.string_intern_table str with
  | Some addr -> addr
  | None ->
      let len_string = String.length str in
      let addr = heap_allocate state ~size:(len_string + 1) ~tag:String_tag in
      let rec helper_set_char char_index =
        if char_index >= len_string then ()
        else
          let char_val = Float.of_int (Char.code (String.get str char_index)) in
          heap_set_child state ~address:addr ~child_index:char_index
            ~value:char_val;
          helper_set_char (char_index + 1)
      in
      helper_set_char 0;
      StringLRU.add state.string_intern_table str addr;
      addr

let heap_get_true state = (get_canonical_values state).true_addr

let heap_get_false state =
  (* Printf.printf "heap get false"; *)
  (get_canonical_values state).false_addr

let heap_get_undefined state = (get_canonical_values state).undefined_addr

let heap_allocate_value state lit_value =
  match lit_value with
  | Types.Int i -> heap_allocate_number state (Float.of_int i)
  | Float f -> heap_allocate_number state f
  | String s -> heap_allocate_string state s
  | Boolean b -> (
      match b with true -> heap_get_true state | false -> heap_get_false state)
  | Undefined -> heap_get_undefined state

let heap_get_number_value state addr = heap_get state (addr + 1)

let heap_get_bool_value state addr =
  match heap_get_tag state addr with
  | True_tag -> true
  | False_tag -> false
  | _ -> failwith "Unexpected non-boolean tag in get bool value"

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

let heap_get_ref_value state addr = heap_get state (addr + 1) |> Float.to_int

let heap_allocate_ref state number =
  let addr = heap_allocate state ~size:2 ~tag:Ref_tag in
  heap_set state ~address:(addr + 1) ~word:number;
  addr

let heap_free state addr =
  (* 1. Get the current free pointer *)
  let current_free = !(state.free) in

  Printf.printf "Freed address: %d\n" addr;

  (* change the tag of the node to unassigned *)
  heap_set_tag state addr Unassigned_tag;

  (* 2. Set the freed node's first word to point to the current free node *)
  heap_set state ~address:addr ~word:(Float.of_int current_free);

  (* 3. Update the free pointer to point to the newly freed node *)
  state.free := addr

let heap_free_at_pos state ~env_addr ~frame_index ~val_index =
  (* 1. Get the frame address from the environment *)
  let frame_addr =
    heap_get_child_as_int state ~address:env_addr ~child_index:frame_index
  in

  (* 2. Get the value address from the frame *)
  let value_addr =
    heap_get_child_as_int state ~address:frame_addr ~child_index:val_index
  in

  (* 3. Check if the value is unassigned *)
  match heap_get_tag state value_addr with
  | Unassigned_tag -> failwith "Nothing to free: slot is already unassigned"
  | _ ->
      (* 4. Free the value *)
      heap_free state value_addr;

      (* 5. Mark the slot as unassigned *)
      heap_set_child state ~address:frame_addr ~child_index:val_index
        ~value:(Float.of_int (get_canonical_values state).unassigned_addr)

let heap_set_byte_at_offset state ~addr ~offset ~value =
  (* Calculate the byte address *)
  let byte_addr = (addr * state.config.word_size) + offset in

  (* Set the byte value at the calculated address *)
  Buffer.set_uint8_at_offset state.buffer byte_addr value

let heap_get_byte_at_offset state ~addr ~offset =
  (* Calculate the byte address *)
  let byte_addr = (addr * state.config.word_size) + offset in

  (* Get the byte value at the calculated address *)
  Buffer.get_uint8_at_offset state.buffer byte_addr

let heap_allocate_closure state ~arity ~code_addr ~env_addr =
  (* 1. Allocate space for closure (2 words) *)
  let addr = heap_allocate state ~size:2 ~tag:Closure_tag in

  (* 2. Set arity at offset 1 *)
  heap_set_byte_at_offset state ~addr ~offset:1 ~value:arity;

  (* 3. Set code address (PC) at offset 2 using 2 bytes *)
  heap_set_two_bytes_in_word_at_offset state ~addr ~offset:2 ~value:code_addr;

  (* 4. Set environment address at address + 1 *)
  heap_set state ~address:(addr + 1) ~word:(Float.of_int env_addr);

  addr

let heap_get_closure_arity state addr =
  heap_get_byte_at_offset state ~addr ~offset:1

let heap_get_closure_code_addr state addr =
  heap_get_two_bytes_in_word_at_offset state ~addr ~offset:2

let heap_get_closure_env_addr state addr =
  heap_get_child_as_int state ~address:addr ~child_index:0

let heap_allocate_frame state ~num_values =
  let res = heap_allocate state ~size:(num_values + 1) ~tag:Frame_tag in
  res

let heap_allocate_builtin state ~builtin_id =
  (* print the builtin id *)
  let addr = heap_allocate state ~size:1 ~tag:Builtin_tag in
  heap_set_byte_at_offset state ~addr ~offset:1 ~value:builtin_id;
  addr

let heap_allocate_builtin_frame state =
  (* print the builtin id *)
  Printf.printf "Allocating builtin frame\n";
  let builtins = Builtins.all_builtins () in
  let frame_addr =
    heap_allocate_frame state ~num_values:(List.length builtins)
  in
  List.iteri
    (fun i { Builtins.id; _ } ->
      let builtin_addr = heap_allocate_builtin state ~builtin_id:id in
      heap_set_child state ~address:frame_addr ~child_index:i
        ~value:(Float.of_int builtin_addr))
    builtins;
  frame_addr

let heap_get_builtin_id state addr =
  heap_get_byte_at_offset state ~addr ~offset:1

let pretty_print_heap state =
  let rec print_node addr =
    if addr >= heap_size_words then ()
    else
      try
        let tag = heap_get_tag state addr in
        let num_children = heap_get_num_children state addr in
        Printf.printf "[%04d]: %s" addr (string_of_node_tag tag);

        (* Print node-specific content *)
        (match tag with
        | Number_tag ->
            let value = heap_get_number_value state addr in
            Printf.printf " (value: %f)" value
        | String_tag ->
            let value = heap_get_string_value state addr in
            Printf.printf " (value: \"%s\")" value
        | Ref_tag ->
            let value = heap_get_ref_value state addr in
            Printf.printf " (points to: %d)" value
        | Callframe_tag ->
            let pc = heap_get_callframe_pc state addr in
            let env = heap_get_callframe_env state addr in
            Printf.printf " (pc: %d, env: %d)" pc env
        | Closure_tag ->
            let arity = heap_get_closure_arity state addr in
            let code = heap_get_closure_code_addr state addr in
            let env = heap_get_closure_env_addr state addr in
            Printf.printf " (arity: %d, code: %d, env: %d)" arity code env
        | Frame_tag ->
            let size = heap_get_size state addr in
            Printf.printf " (size: %d)" size
        | Environment_tag ->
            let size = heap_get_size state addr in
            Printf.printf " (num_frames: %d)" (size - 1)
        | Unassigned_tag -> Printf.printf " (unassigned)"
        | _ -> Printf.printf " (unknown tag)");

        (* Print children if any *)
        if num_children > 0 then (
          Printf.printf " (children: ";
          for j = 0 to num_children - 1 do
            let child_addr =
              Float.to_int (heap_get_child state ~address:addr ~child_index:j)
            in
            let child_tag = heap_get_tag state child_addr in
            Printf.printf "%d(%s) " child_addr (string_of_node_tag child_tag)
          done;
          Printf.printf ")");
        Printf.printf "\n";

        (* Move to next node *)
        print_node (addr + state.config.node_size)
      with Failure msg ->
        Printf.printf "[%04d]: %s\n" addr "Unknown tag";
        Printf.printf "Error: %s at address %d\n" msg addr;
        (* If we can't read the tag, move one word at a time until we find a valid tag *)
        let next_addr = addr + 1 in
        if next_addr >= heap_size_words then () else print_node next_addr
  in
  print_node 0

let create () =
  let state =
    {
      config = initial_config;
      buffer =
        Buffer.create (initial_config.heap_size_words * initial_config.word_size);
      free = ref 0;
      canonical_values = None;
      string_intern_table = StringLRU.create 10;
    }
  in
  (* Initialize free pointers first *)
  let rec set_free_pointers cur_state prev_addr cur_addr =
    if cur_addr > heap_size_words - state.config.node_size then
      heap_set cur_state ~address:prev_addr ~word:(Float.of_int (-1))
      (* sentinel *)
    else (
      heap_set cur_state ~address:prev_addr ~word:(Float.of_int cur_addr);
      set_free_pointers cur_state cur_addr (cur_addr + state.config.node_size))
  in
  set_free_pointers state 0 initial_config.node_size;

  (* Then allocate canonical values *)
  heap_allocate_canonical_values state;

  (* create an env with 1 frame*)
  let env_addr = heap_allocate_environment state ~num_frames:0 in

  (* Printf.printf "free: %d\n" !(state.free); *)
  let builtin_frame_addr = heap_allocate_builtin_frame state in

  let _ = heap_env_extend state ~new_frame_addr:builtin_frame_addr ~env_addr in

  (* Printf.printf "free: %d\n" !(state.free); *)
  (* pretty_print_heap state; *)
  state
