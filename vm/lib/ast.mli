type ast_node =
  | Literal of Value.lit_value
  | Variable of string
  | Block of ast_node
  | Sequence of ast_node list
  | While of { pred : ast_node; body : ast_node }
  | Let of { sym : string; expr : ast_node }
  | Const of { sym : string; expr : ast_node }
  | Binop of { sym : string; frst : ast_node; scnd : ast_node }
  | Unop of { sym : string; frst : ast_node }
  | Lam of { prms : string list; body : ast_node }
  | Fun of { sym : string; prms : string list; body : ast_node }
  | Nam of string
  | Ret of ast_node
  | App of { fun_nam : ast_node; args : ast_node list }
[@@deriving show]


val of_json : Yojson.Basic.t -> ast_node


