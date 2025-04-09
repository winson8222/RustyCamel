type ast_node =
  | Literal of Value.lit_value
  | Variable of string
  | Block of ast_node
  | Sequence of ast_node list
  | Let of { sym : string; expr : ast_node }
  | Const of { sym : string; expr : ast_node }
  | Binop of { sym : string; frst : ast_node; scnd : ast_node }
  | Unop of { sym : string; frst : ast_node }
  | Fun of { sym : string; prms : string list; body : ast_node }
  | Nam of string
  | Ret of ast_node
  | App of { func : ast_node; args : ast_node list }
  | Lam of { prms : string list; body : ast_node }
[@@deriving show]

type typed_ast =
  | Literal of Value.lit_value
  | Variable of string
  | Block of typed_ast
  | Sequence of typed_ast list
  | Let of { sym : string; expr : typed_ast; declared_type : Types.value_type }
  | Ld of string
  | Const of {
      sym : string;
      expr : typed_ast;
      declared_type : Types.value_type;
    }
  | Binop of { sym : string; frst : typed_ast; scnd : typed_ast }
  | Unop of { sym : string; frst : typed_ast }
  | Lam of { prms : string list; body : typed_ast }
  | Fun of {
      sym : string;
      prms : string list;
      declared_type : Types.value_type;
      body : typed_ast;
    }
  | Nam of string
  | Ret of typed_ast
  | App of { func : typed_ast; args : typed_ast list }
[@@deriving show]

(* Produces typed ast *)
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
          declared_type = json |> member "declared_type" |> Types.of_json;
        }
  | "const" ->
      Const
        {
          sym = json |> member "sym" |> to_string;
          expr =
            (match json |> member "lit" with
            | `Null -> json |> member "expr" |> of_json
            | lit -> of_json lit);
          declared_type = json |> member "declared_type" |> Types.of_json;
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
  | "fun" ->
      let sym = json |> member "sym" |> to_string in
      let prms =
        json |> member "prms" |> to_list
        |> List.map (fun p -> p |> member "name" |> to_string)
      in
      let body = json |> member "body" |> of_json in
      let declared_type =
        json |> member "declared_type" |> Types.of_json
      in
      Fun { sym; prms; body; declared_type }
  | "lam" ->
      let prms =
        json |> member "prms" |> to_list
        |> List.map (fun p -> p |> member "name" |> to_string)
      in
      let body = json |> member "body" |> of_json in
      Lam { prms; body }
  | "ret" -> Ret (json |> member "expr" |> of_json)
  | "app" ->
      let fun_expr = json |> member "fun" |> of_json in
      let args = json |> member "args" |> to_list |> List.map of_json in
      App { func = fun_expr; args }
  | tag -> failwith ("Unknown tag: " ^ tag)

let rec strip_types (ast : typed_ast) : ast_node =
  match ast with
  | Literal value -> Literal value
  | Variable sym -> Variable sym
  | Block body -> Block (strip_types body)
  | Sequence stmts -> Sequence (List.map strip_types stmts)
  | Let { sym; expr; _ } ->
      Let { sym; expr = strip_types expr }
      (* Strip type from the expression in the Let *)
  | Ld sym ->
      Variable sym (* Ld in typed_ast corresponds to Variable in core_ast *)
  | Const { sym; expr; _ } ->
      Let { sym; expr = strip_types expr }
      (* Const also corresponds to Let in core_ast *)
  | Binop { sym; frst; scnd } ->
      Binop { sym; frst = strip_types frst; scnd = strip_types scnd }
      (* Strip types from operands in the Binop *)
  | Unop { sym; frst } ->
      Unop { sym; frst = strip_types frst }
      (* Strip type from operand in the Unop *)
  | Lam { prms; body } ->
      Fun { sym = "anonymous"; prms; body = strip_types body }
      (* Convert Lam to Function *)
  | Fun { sym; prms; body; _ } ->
      Fun { sym; prms; body = strip_types body } (* Fun to Function *)
  | Nam sym -> Nam sym (* Just return the name (no type info) *)
  | Ret expr ->
      Ret (strip_types expr) (* Return with stripped type expression *)
  | App { func; args } ->
      App { func = strip_types func; args = List.map strip_types args }
(* Strip types from the function and arguments in the App *)
