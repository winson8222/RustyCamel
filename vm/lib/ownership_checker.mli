type t 
val create : unit -> t
val check_ownership: Ast.ast_node -> t -> (unit, string) Result.t