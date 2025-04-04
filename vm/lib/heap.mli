type t

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

val initial_config: config
val create :  t (* TODO: Take in heap size as arg *)

val heap_env_extend : t -> new_frame_addr:int -> int (* returns new address of the head env *)

val heap_get_word : t -> int -> float
val heap_set_word : t -> address:int -> word:float -> unit

val heap_get_child : t -> address:int -> child_index:int -> float
val heap_set_child : t -> address:int -> child_index:int -> value:float -> unit

val heap_get_tag : t -> int -> node_tag
val heap_set_tag : t -> int -> node_tag -> unit

val heap_get_size : t -> int -> int
val heap_set_size : t -> int -> int -> unit

val heap_get_num_children : t -> int -> int 



val heap_allocate : t -> size:int -> tag:node_tag -> int

val debug_print_bytes : t -> int -> int -> unit

val heap_set_frame_children_to_unassigned : t -> frame_addr:int -> num_children:int -> unit

val heap_allocate_environment : t -> num_frames:int -> int
val heap_allocate_blockframe: t -> env_addr:int  -> int