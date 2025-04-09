type ast_node =
  | Literal of Value.lit_value
  | Variable of string
  | Block of ast_node
  | Sequence of ast_node list
  | Let of { sym : string; expr : ast_node }
  | Ld of string
  | Const of { sym : string }
  | BinOp of { sym : string; frst : ast_node; scnd : ast_node }
  | Function of { sym : string; params : string list; body : ast_node }
  | Nam of string
  | Ret of ast_node
  | BorrowExpr of { is_mutable : bool; expr : ast_node }
[@@deriving show]

let rec of_json json =
  let open Yojson.Basic.Util in
  let tag = json |> member "tag" |> to_string in
  match tag with
  | "lit" -> (
      let value = member "val" json in
      match value with
      | `Int i -> Literal (Int i)
      | `String s -> Literal (String s)
      | _ -> failwith "Invalid literal")
  | "blk" -> Block (of_json (member "body" json))
  | "seq" ->
      let stmts = json |> member "stmts" |> to_list in
      Sequence (List.map of_json stmts)
  | "let" ->
      Let
        {
          sym = json |> member "sym" |> to_string;
          expr = json |> member "expr" |> of_json;
        }
  | "const" -> Const { sym = json |> member "sym" |> to_string }
  | "binop" ->
      BinOp
        {
          sym = json |> member "sym" |> to_string;
          frst = of_json (member "frst" json);
          scnd = of_json (member "scnd" json);
        }
  | "nam" -> Nam (member "sym" json |> to_string)
  | "borrow" ->
      BorrowExpr
        {
          is_mutable = member "mutable" json |> to_bool;
          expr = member "expr" json |> of_json;
        }
  | tag -> failwith ("Unknown tag: " ^ tag)
