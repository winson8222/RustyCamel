type t 

val create: t -> t

val check_types : t -> Ast.ast_node list -> (unit, string) Result.t