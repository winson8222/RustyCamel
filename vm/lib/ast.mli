type unop_sym = Negate | LogicalNot [@@deriving show]

type binop_sym =
  | Add
  | Subtract
  | Multiply
  | Divide
  | LessThan
  | LessThanEqual
  | GreaterThan
  | GreaterThanEqual
  | Equal
  | NotEqual
[@@deriving show]

type ast_node =
  | Literal of Types.lit_value
  | Nam of string
  | Block of ast_node
  | Sequence of ast_node list
  | While of { pred : ast_node; body : ast_node }
  | Cond of { pred : ast_node; cons : ast_node; alt : ast_node }
  | Let of { sym : string; expr : ast_node }
  | Const of { sym : string; expr : ast_node }
  | Assign of { sym : string; expr : ast_node }
  | Binop of { sym : binop_sym; frst : ast_node; scnd : ast_node }
  | Unop of { sym : unop_sym; frst : ast_node }
  | Fun of { sym : string; prms : string list; body : ast_node }
  | Ret of ast_node
  | App of { fun_nam : ast_node; args : ast_node list }
  | Borrow of { expr : ast_node }
  | Deref of ast_node
[@@deriving show]

type typed_ast =
  | Literal of Types.lit_value
  | Nam of string
  | Block of typed_ast
  | Sequence of typed_ast list
  | Let of {
      sym : string;
      expr : typed_ast;
      declared_type : Types.value_type;
      is_mutable : bool;
    }
  | While of { pred : typed_ast; body : typed_ast }
  | Cond of { pred : typed_ast; cons : typed_ast; alt : typed_ast }
  | Const of {
      sym : string;
      expr : typed_ast;
      declared_type : Types.value_type;
    }
  | Assign of { sym : string; expr : typed_ast }
  | Binop of { sym : binop_sym; frst : typed_ast; scnd : typed_ast }
  | Unop of { sym : unop_sym; frst : typed_ast }
  | Fun of {
      sym : string;
      prms : string list;
      declared_type : Types.value_type;
      body : typed_ast;
    }
  | Borrow of { is_mutable : bool; expr : typed_ast }
  | Deref of typed_ast
  | Ret of typed_ast
  | App of { fun_nam : typed_ast; args : typed_ast list }
[@@deriving show]

val of_json : Yojson.Basic.t -> typed_ast

val strip_types : typed_ast -> ast_node
(** [strip_types ast] removes all type annotations from the AST. This is useful
    for converting a typed AST to a core AST. *)
