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
  | Lam of { prms : string list; body : ast_node }
  | Fun of { sym : string; prms : string list; body : ast_node }
  | Nam of string
  | Ret of ast_node
  | App of { func : ast_node; args : ast_node list }
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
      | `Bool b -> Literal (Boolean b)
      | _ -> failwith "Invalid literal")
  | "blk" -> Block (of_json (member "body" json))
  | "seq" ->
      let stmts = json |> member "stmts" |> to_list in
      Sequence (List.map of_json stmts)
  | "let" ->
      Let
        {
          sym = json |> member "sym" |> to_string;
          expr =
            (match json |> member "lit" with
            | `Null -> json |> member "expr" |> of_json
            | lit -> of_json lit);
        }
  | "const" ->
      Const
        {
          sym = json |> member "sym" |> to_string;
          expr = json |> member "expr" |> of_json;
        }
  | "binop" ->
      Binop
        {
          sym = json |> member "sym" |> to_string;
          frst = of_json (member "frst" json);
          scnd = of_json (member "scnd" json);
        }
  | "unop" ->
      Unop
        {
          sym = json |> member "sym" |> to_string;
          frst = of_json (member "frst" json);
        }
  | "nam" -> Nam (member "sym" json |> to_string)
  | "borrow" ->
      BorrowExpr
        {
          is_mutable = member "mutable" json |> to_bool;
          expr = member "expr" json |> of_json;
        }
  | "fun" ->
      let sym = json |> member "sym" |> to_string in
      let prms = json |> member "prms" |> to_list |> List.map (fun p -> p |> member "name" |> to_string) in
      let body = json |> member "body" |> of_json in
      Fun { sym; prms; body }
  | "lam" ->
      let prms = json |> member "prms" |> to_list |> List.map (fun p -> p |> member "name" |> to_string) in
      let body = json |> member "body" |> of_json in
      Lam { prms; body }
  | "ret" -> Ret (json |> member "expr" |> of_json)
  | "app" ->
      let fun_expr = json |> member "fun" |> of_json in
      let args = json |> member "args" |> to_list |> List.map of_json in
      App { func = fun_expr; args }
  | tag -> failwith ("Unknown tag: " ^ tag)


