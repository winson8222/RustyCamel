type t

val create : unit -> t
val check_type : Ast.typed_ast -> t -> (unit, string) Result.t
val make_type_err_msg : Types.value_type -> Types.value_type -> string
