type t

type config = { 
  heap_size_words: int;
  word_size: int;
  tag_offset: int; 
  size_offset: int;
  forwarding_address_offset: int;
  to_space: int;
  free: int ref;
} 

val initial_config: config
val create :  t

val heap_get_word : t -> int -> float
val heap_set_word : t -> int -> float -> unit

val heap_get_child : t -> int -> int -> float
val heap_set_child : t -> int -> int -> float -> unit

val heap_get_tag : t -> int -> int

val heap_get_size : t -> int -> int
val  heap_set_tag : t -> int -> int -> unit

val heap_set_size : t -> int -> int -> unit

val allocate : t -> int -> int

val debug_print_bytes : t -> int -> int -> unit