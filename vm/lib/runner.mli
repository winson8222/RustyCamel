
type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined
  | VAddress of int

type vm_error =
  | TypeError of string

val run  : Compiler.compiled_instruction list -> (vm_value, vm_error) Result.t