type t 

val create: unit -> t

val check_type : Ast.ast_node -> t -> (unit, string) Result.t