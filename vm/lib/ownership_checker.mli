type t 
val create : unit -> t
val check_ownership: Ast.ast_node -> t -> (unit, string) Result.t

type ownership_status = Owned | ImmutablyBorrowed | MutablyBorrowed | Moved
[@@deriving show]


val make_borrow_err_msg: string -> ownership_status -> string
val make_acc_err_msg: string -> ownership_status -> string
val make_move_err_msg: string -> ownership_status -> string