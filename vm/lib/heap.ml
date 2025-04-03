open Buffer
(* address is in byte, so we choose int as we can already support addresses of 32 bits *)

type config = { 
  heap_size_words: int;
  word_size: int;
  tag_offset: int; 
  size_offset: int;
  forwarding_address_offset: int;
  to_space: int;
  free: int ref;
} 

type t = {
  config : config;
  buffer: Buffer.t
}

let heap_size_words = 300
let to_space = heap_size_words / 2

let initial_config = {
  heap_size_words=heap_size_words;
  word_size=8;
  tag_offset=0;
  size_offset=2;
  forwarding_address_offset=0;
  to_space=to_space;
  free= ref to_space
}

let create = 
  {
    config= initial_config;
    buffer=create (initial_config.heap_size_words * initial_config.word_size);
  }

(* Exported functions *)
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
  set_uint8_at_offset state.buffer (addr_byte + state.config.tag_offset) tag

let heap_set_size state address size =
  let addr_byte = address * state.config.word_size in
  set_uint16_at_offset state.buffer (addr_byte + state.config.size_offset) size

(* Allocation function *)
let allocate state size_in_words =
  let free = state.config.free in
  let addr_in_words = !free / state.config.word_size in
  free := !free + (size_in_words * state.config.word_size);
  addr_in_words

let debug_print_bytes state byte_addr count =
  Printf.printf "Memory at %d (byte addr %d):\n" byte_addr (byte_addr * state.config.word_size);
  for i = 0 to count - 1 do
    Printf.printf "%02x " (get_uint8_at_offset state.buffer (byte_addr * state.config.word_size + i));
    if (i + 1) mod 8 = 0 then Printf.printf "\n";
  done;
  Printf.printf "\n"
