type t

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

type config = {
  heap_size_words : int;
  node_size : int;
  word_size : int;
  tag_offset : int;
  size_offset : int;
}

val initial_config : config
val create : unit -> t (* TODO: Take in heap size as arg *)

val heap_env_extend :
  t ->
  new_frame_addr:int ->
  env_addr:int ->
  int (* returns new address of the head env *)

val heap_get : t -> int -> float
val heap_set : t -> address:int -> word:float -> unit
val heap_get_child : t -> address:int -> child_index:int -> float
val heap_set_child : t -> address:int -> child_index:int -> value:float -> unit
val heap_get_tag : t -> int -> node_tag
val heap_set_tag : t -> int -> node_tag -> unit
val heap_get_size : t -> int -> int
val heap_set_size : t -> int -> int -> unit
val heap_get_num_children : t -> int -> int
val heap_allocate : t -> size:int -> tag:node_tag -> int
val heap_allocate_number : t -> float -> int
val heap_allocate_string : t -> string -> int
val heap_allocate_value : t -> Types.lit_value -> int

val heap_set_frame_children_to_unassigned :
  t -> frame_addr:int -> num_children:int -> unit

val heap_allocate_environment : t -> num_frames:int -> int

val heap_set_env_val_addr_at_pos :
  t -> env_addr:int -> frame_index:int -> val_index:int -> val_addr:int -> unit

val heap_get_env_val_addr_at_pos :
  t -> env_addr:int -> frame_index:int -> val_index:int -> int

val heap_allocate_callframe : t -> pc:int -> env_addr:int -> int
val heap_allocate_blockframe : t -> env_addr:int -> int
val heap_get_blockframe_env : t -> int -> int
val heap_allocate_builtin_frame : t -> int
val heap_allocate_builtin : t -> builtin_id:int -> int
val heap_get_number_value : t -> int -> float
val heap_get_bool_value : t -> int -> bool
val heap_get_string_value : t -> int -> string
val debug_print_bytes : t -> int -> int -> unit
val is_callframe : t -> int -> bool
val heap_get_callframe_pc : t -> int -> int
val heap_get_callframe_env : t -> int -> int
val heap_get_ref_value : t -> int -> int
val heap_allocate_ref : t -> float -> int
val heap_free : t -> int -> unit

val heap_free_at_pos :
  t -> env_addr:int -> frame_index:int -> val_index:int -> unit

val heap_get_true : t -> int
val heap_get_false : t -> int
val heap_get_undefined : t -> int

val heap_allocate_closure :
  t -> arity:int -> code_addr:int -> env_addr:int -> int

val heap_get_closure_arity : t -> int -> int
val heap_get_closure_code_addr : t -> int -> int
val heap_get_closure_env_addr : t -> int -> int
val heap_get_builtin_id : t -> int -> int
val string_of_node_tag : node_tag -> string
val heap_allocate_frame : t -> num_values:int -> int
val pretty_print_heap : t -> unit
val get_heap_usage : t -> unit