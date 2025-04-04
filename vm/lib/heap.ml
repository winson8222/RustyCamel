open Buffer
(* address is in byte, so we choose int as we can already support addresses of 32 bits *)

type node_tag = 
  | False_tag 
  | True_tag  
  | Number_tag         
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
  heap_size_words: int;
  word_size: int;
  tag_offset: int; 
  size_offset: int;
} 

type t = {
  config : config;
  buffer: Buffer.t;
  free: int ref;
  env_addr: int ref;
}

let heap_size_words = 300
let to_space = heap_size_words / 2

let initial_config = {
  heap_size_words=heap_size_words;
  word_size=8;
  tag_offset=0;
  size_offset=2;
}

(* Exported functions *)

let heap_get_word state address =
  let addr_byte = address * state.config.word_size in
  get_float64_at_offset state.buffer addr_byte

let heap_set_word state ~address ~word =
  let addr_byte = address * state.config.word_size in
  set_float64_at_offset state.buffer addr_byte word

let heap_get_child state ~address ~child_index =
  heap_get_word state (address + 1 + child_index) 

let heap_set_child state ~address ~child_index ~value =
  heap_set_word state ~address:(address + 1 + child_index) ~word:value

let heap_get_tag state address =
  let addr_byte = address * state.config.word_size in
  let tag_number = get_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset) in
  match node_tag_of_enum tag_number with 
  | Some tag -> tag
  | None -> failwith "Unrecognized tag"

let heap_get_size state address =
  let addr_byte = address * state.config.word_size in
  get_uint16_at_offset state.buffer (addr_byte + state.config.size_offset)


let heap_get_num_children state addr = 
  let tag = heap_get_tag state addr in
  match tag with 
  | Number_tag -> 0
  | _ -> (heap_get_size state addr) - 1


let heap_set_tag state address tag =
  let addr_byte = address * state.config.word_size in
  let tag_number = node_tag_to_enum tag in
  set_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset) tag_number

let heap_set_size state address size =
  let addr_byte = address * state.config.word_size in
  set_uint16_at_offset state.buffer (addr_byte + state.config.size_offset) size

let debug_print_bytes state byte_addr count =
  Printf.printf "Memory at %d (byte addr %d):\n" byte_addr (byte_addr * state.config.word_size);
  for i = 0 to count - 1 do
    Printf.printf "%02x " (get_uint8_at_offset state.buffer (byte_addr * state.config.word_size + i));
    if (i + 1) mod 8 = 0 then Printf.printf "\n";
  done;
  Printf.printf "\n"

let heap_allocate state ~size ~tag = 
  if !(state.free) = -1 then
    failwith "Heap ran out of memory"
  else 
    let addr = !(state.free) in
    heap_set_tag state addr tag;
    heap_set_size state addr size;
    state.free := Float.to_int (heap_get_word state addr);
    addr

let create = 
  let rec set_free_pointers state prev_addr cur_addr =
    if cur_addr >= heap_size_words then
      ()  (* Base case: reached end of heap *)
    else (
      heap_set_word state ~address:prev_addr ~word:(Float.of_int cur_addr);
      set_free_pointers state cur_addr (cur_addr + state.config.word_size)
    )
  in
  let state = {
    config = initial_config;
    buffer = create (initial_config.heap_size_words * initial_config.word_size);
    free = ref to_space;
    env_addr = ref 0;
  } in
  set_free_pointers state 0 initial_config.word_size;
  state

(* One child : Blockframe address *)
let heap_allocate_blockframe state ~env_addr = 
  let blockframe_addr = heap_allocate state ~size:2 ~tag:Blockframe_tag in
  heap_set_word state ~address:(blockframe_addr + 1) ~word:(Float.of_int env_addr);
  blockframe_addr

let heap_allocate_environment state ~num_frames = 
  heap_allocate state ~size:(num_frames+1) ~tag:Environment_tag

let helper_copy_env_frames state ~old_env_addr ~new_env_addr = 
  let num_children = heap_get_num_children state old_env_addr in
  let rec helper_copy_env_frames child_index  = 
    if child_index >= num_children then
      ()
    else 
      (let child_node = heap_get_child state ~address:old_env_addr ~child_index:child_index in
       heap_set_child state ~address:new_env_addr ~child_index:child_index ~value:child_node;
       helper_copy_env_frames (child_index + 1) ) in
  helper_copy_env_frames 0

let heap_env_extend state ~new_frame_addr = 
  let env_addr = !(state.env_addr) in
  let old_num_frames = heap_get_size state env_addr in
  let new_env_addr = heap_allocate_environment state ~num_frames:(old_num_frames+1 ) in
  helper_copy_env_frames state ~old_env_addr:env_addr ~new_env_addr:new_env_addr;
  heap_set_child state ~address:new_env_addr ~child_index:old_num_frames ~value:(Float.of_int new_frame_addr);
  new_env_addr

(* TODO: Check correctness *)
let heap_set_frame_children_to_unassigned state ~frame_addr ~num_children = 
  let make_unassigned_word () =
    let buffer = Buffer.create state.config.word_size in
    Buffer.set_uint8_at_offset buffer 0 (node_tag_to_enum Unassigned_tag);
    Buffer.get_float64_at_offset buffer 0
  in
  let rec helper cur_child_index = 
    if cur_child_index >= num_children then
      () 
    else
      ( heap_set_child state ~address:frame_addr ~child_index:cur_child_index ~value:(make_unassigned_word ());
        helper (cur_child_index + 1) ) in 
  helper 0


