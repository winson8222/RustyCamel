type t

type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined
  | VBoolean of bool
  | VAddress of int (* byte address *)

type vm_error = TypeError of string

val create : t
val run : Compiler.compiled_instruction list -> (vm_value, vm_error) Result.t
val string_of_vm_value : vm_value -> string
val string_of_vm_error : vm_error -> string
