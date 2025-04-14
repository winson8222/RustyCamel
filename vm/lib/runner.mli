type t


type vm_value =
  | VNumber of float
  | VString of string
  | VUndefined
  | VBoolean of bool
  | VRef of vm_value
  | VAddress of int (* byte address *)
  | VClosure of int * int * int
  | VFrame of int
[@@deriving show]

type vm_error = TypeError of string

val create : unit -> t

val run :
  t -> Compiler.compiled_instruction list -> (vm_value, vm_error) Result.t

val string_of_vm_value : vm_value -> string
val string_of_vm_error : vm_error -> string
