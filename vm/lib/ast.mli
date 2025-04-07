type param_type = {
  type_name: string;
  ownership: string;
} [@@deriving show]

type param = {
  name: string;
  param_type: param_type;
} [@@deriving show]

type ast_node =
  | Literal of Value.lit_value
  | Variable of string
  | Block of ast_node
  | Sequence of ast_node list
  | Let of { sym : string; expr : ast_node }
  | Ld of string
  | Const of { sym : string; expr : ast_node }
  | Binop of { sym : string; frst : ast_node; scnd : ast_node }
  | Unop of { sym : string; frst : ast_node }
  | Lam of { prms : param list; body : ast_node }
  | Fun of { sym : string; prms : param list; ret_type: param_type option; body : ast_node }
  | Nam of string
  | Ret of ast_node
  | App of { func : ast_node; args : ast_node list }
[@@deriving show]

val of_json : Yojson.Basic.t -> ast_node
