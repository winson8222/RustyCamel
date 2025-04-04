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
let heap_env_extend state new_frame_addr = 
  let _buffer = state.buffer in
  new_frame_addr

let heap_get_word state address =
  let addr_byte = address * state.config.word_size in
  get_float64_at_offset state.buffer addr_byte

let heap_set_word state address x =
  let addr_byte = address * state.config.word_size in
  set_float64_at_offset state.buffer addr_byte x

let heap_get_child state address child_index =
  heap_get_word state (address + 1 + child_index) 

let heap_set_child state address child_index value =
  heap_set_word state (address + 1 + child_index)  value

let heap_get_tag state address =
  let addr_byte = address * state.config.word_size in
  get_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset)

let heap_get_size state address =
  let addr_byte = address * state.config.word_size in
  get_uint16_at_offset state.buffer (addr_byte + state.config.size_offset)

let heap_set_tag state address tag =
  let addr_byte = address * state.config.word_size in
  set_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset) (node_tag_to_enum tag)

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

let heap_allocate state size tag = 
  if !(state.free) = -1 then
    failwith "Heap ran out of memory"
  else 
    let addr = !(state.free) in
    heap_set_tag state addr tag;
    heap_set_size state addr size;
    state.free := Float.to_int (heap_get_word state addr)

let create = 
  let rec set_free_pointers state prev_addr cur_addr =
    if cur_addr >= heap_size_words then
      ()  (* Base case: reached end of heap *)
    else (
      heap_set_word state prev_addr (Float.of_int cur_addr);
      set_free_pointers state cur_addr (cur_addr + state.config.word_size)
    )
  in
  let state = {
    config = initial_config;
    buffer = create (initial_config.heap_size_words * initial_config.word_size);
    free = ref to_space
  } in
  set_free_pointers state 0 initial_config.word_size;
  state

