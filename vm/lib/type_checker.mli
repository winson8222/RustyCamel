type t 

val create: unit -> t

val check_type : Ast.typed_ast -> t -> (unit, string) Result.t