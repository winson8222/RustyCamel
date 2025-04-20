(* builtin.mli *)

type builtin = {
  name : string;
  id : int;
  param_types : Types.value_type list list;
  ret_type : Types.value_type;
}

val register_builtin :
  name:string ->
  param_types:Types.value_type list list ->
  ret_type:Types.value_type ->
  builtin
(** Registers a builtin function with a name, parameter types, and return type
*)

val all_builtins : unit -> builtin list
(** Returns the full list of registered builtins *)

val get_builtin_name_by_id : int -> string
(** Looks up a builtin by its ID *)

val get_builtin_id_by_name : string -> int
(** Returns the ID of a builtin by its name *)

val is_builtin_name : string -> bool
(** Checks if a given name is a builtin *)

val get_builtin_param_types : int -> Types.value_type list list
(** Gets the parameter types for a builtin by ID *)

val get_builtin_ret_type : int -> Types.value_type
(** Gets the return type for a builtin by ID *)

val validate_builtin_args : int -> Types.value_type list -> bool
(** Validates that a list of argument types matches the builtin's parameter
    types *)
