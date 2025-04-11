type ast_node =
  | Literal of Value.lit_value
  | Nam of string
  | Block of ast_node
  | Sequence of ast_node list
  | While of { pred : ast_node; body : ast_node }
  | Cond of { pred : ast_node; cons : ast_node; alt : ast_node }
  | Let of { sym : string; expr : ast_node; is_mutable : bool }
  | Const of { sym : string; expr : ast_node }
  | Assign of { sym : string; expr : ast_node }
  | Binop of { sym : string; frst : ast_node; scnd : ast_node }
  | Unop of { sym : string; frst : ast_node }
  | Fun of { sym : string; prms : string list; body : ast_node }
  | Ret of ast_node
  | App of { fun_nam : ast_node; args : ast_node list }
  | Borrow of { is_mutable : bool; expr : ast_node }
  | Lam of { prms : string list; body : ast_node }
[@@deriving show]

type typed_ast =
  | Literal of Value.lit_value
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
  | Cond of {
      pred : typed_ast;
      cons : typed_ast;
      alt : typed_ast;
    }
  | Const of {
      sym : string;
      expr : typed_ast;
      declared_type : Types.value_type;
    }
  | Assign of { sym : string; expr : typed_ast }
  | Binop of { sym : string; frst : typed_ast; scnd : typed_ast }
  | Unop of { sym : string; frst : typed_ast }
  | Lam of { prms : string list; body : typed_ast }
  | Fun of {
      sym : string;
      prms : string list;
      declared_type : Types.value_type;
      body : typed_ast;
    }
  | Borrow of { is_mutable : bool; expr : typed_ast }
  | Ret of typed_ast
  | App of { fun_nam : typed_ast; args : typed_ast list }
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
          is_mutable = json |> member "is_mutable" |> to_bool;
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
  | "borrow" ->
      Borrow
        {
          is_mutable = member "mutable" json |> to_bool;
          expr = member "expr" json |> of_json;
        }
  | "fun" ->
      let sym = json |> member "sym" |> to_string in
      let prms =
        json |> member "prms" |> to_list
        |> List.map (fun p -> p |> member "name" |> to_string)
      in
      let body = json |> member "body" |> of_json in
      let declared_type = json |> member "declared_type" |> Types.of_json in
      Fun { sym; prms; body; declared_type }
  | "lam" ->
      let prms =
        json |> member "prms" |> to_list
        |> List.map (fun p -> p |> member "name" |> to_string)
      in
      let body = json |> member "body" |> of_json in
      Lam { prms; body }
  | "while" ->
      While
        {
          pred = json |> member "pred" |> of_json;
          body = json |> member "body" |> of_json;
        }
  | "ret" ->
      Ret (json |> member "expr" |> of_json)
  | "app" ->
      let fun_nam = json |> member "fun" |> of_json in
      let args = json |> member "args" |> to_list |> List.map of_json in
      App { fun_nam; args }
  | "assmt" ->
      Assign
        {
          sym = json |> member "sym" |> to_string;
          expr = json |> member "expr" |> of_json;
        }
  | "cond" ->
      Cond
        {
          pred = json |> member "pred" |> of_json;
          cons = json |> member "cons" |> of_json;
          alt = json |> member "alt" |> of_json;
        }
  | tag -> failwith ("Unknown tag: " ^ tag)

let rec strip_types (ast : typed_ast) : ast_node =
  match ast with
  | Literal value -> Literal value
  | Nam sym -> Nam sym
  | Block body -> Block (strip_types body)
  | Sequence stmts -> Sequence (List.map strip_types stmts)
  | While { pred; body } ->
      While { pred = strip_types pred; body = strip_types body }
  | Cond { pred; cons; alt } ->
      Cond
        {
          pred = strip_types pred;
          cons = strip_types cons;
          alt = strip_types alt;
        }
  | Let { sym; expr; is_mutable; _ } ->
      Let { sym; expr = strip_types expr; is_mutable }
  | Const { sym; expr; _ } -> Const { sym; expr = strip_types expr }
  | Assign { sym; expr } -> Assign { sym; expr = strip_types expr }
  | Binop { sym; frst; scnd } ->
      Binop { sym; frst = strip_types frst; scnd = strip_types scnd }
  | Unop { sym; frst } -> Unop { sym; frst = strip_types frst }
  | Lam { prms; body } ->
      Fun { sym = "anonymous"; prms; body = strip_types body }
  | Fun { sym; prms; body; _ } -> Fun { sym; prms; body = strip_types body }
  | Ret expr -> Ret (strip_types expr)
  | App { fun_nam; args } ->
      App { fun_nam = strip_types fun_nam; args = List.map strip_types args }
  | Borrow { is_mutable; expr } ->
      Borrow { is_mutable; expr = strip_types expr }
