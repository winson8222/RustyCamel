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

let binop_of_string = function
  | "+" -> Add
  | "-" -> Subtract
  | "*" -> Multiply
  | "/" -> Divide
  | "<" -> LessThan
  | "<=" -> LessThanEqual
  | ">" -> GreaterThan
  | ">=" -> GreaterThanEqual
  | "==" -> Equal
  | "!=" -> NotEqual
  | op -> failwith ("Unknown binary operator: " ^ op)

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

let extract_basic_type (t : Yojson.Basic.t) =
  let open Yojson.Basic.Util in
  match t |> member "name" |> to_string with
  | "i32" -> Types.TInt
  | "bool" -> Types.TBoolean
  | "f32" -> Types.TFloat
  | "String" -> Types.TString
  | other ->
      failwith (Printf.sprintf "unsupported type to extraact in json: %s" other)

let rec extract_type declared_type_json =
  let open Yojson.Basic.Util in
  if declared_type_json = `Null then Types.TUndefined
  else
    (* Printf.printf "declared_type_json type: %s\n" (declared_type_json |> member "type" |> to_string); *)
    match declared_type_json |> member "type" |> to_string with
    | "BasicType" -> extract_basic_type declared_type_json
    | "RefType" ->
        let referenced_type =
          declared_type_json |> member "value" |> extract_type
        in
        let is_mutable = declared_type_json |> member "isMutable" |> to_bool in
        Types.TRef { base = referenced_type; is_mutable }
    | _ -> failwith "unexpected type"

(* Produces typed ast *)
let rec of_json json =
  (* Printf.printf "json: %s\n" (Yojson.Basic.to_string json); *)
  let open Yojson.Basic.Util in
  let tag = json |> member "type" |> to_string in
  (* Printf.printf "Executing tag: %s\n" tag; *)
  match tag with
  | "Program" ->
      let stmts = json |> member "statements" |> to_list in
      Block
        (Sequence
           (List.map
              (fun x ->
                of_json x)
              stmts))
  | "Block" ->
      let stmts = json |> member "statements" |> to_list in
      Block
        (Sequence
           (List.map
              (fun x ->
                of_json x)
              stmts))
  | "Literal" -> (
      let value = member "value" json in
      match value with
      | `Int i -> Literal (Int i)
      | `String s -> Literal (String s)
      | `Bool b -> Literal (Boolean b)
      | _ -> failwith "Invalid literal")
  | "LetDecl" ->
      Let
        {
          sym = json |> member "name" |> to_string;
          expr =
            (match json |> member "value" with
            | `Null -> Literal Undefined
            | expr -> of_json expr);
          is_mutable = json |> member "isMutable" |> to_bool;
          declared_type = json |> member "declaredType" |> extract_type;
        }
  | "const" ->
      Const
        {
          sym = json |> member "sym" |> to_string;
          expr =
            (match json |> member "lit" with
            | `Null -> json |> member "expr" |> of_json
            | lit -> of_json lit);
          declared_type = json |> member "declaredType" |> extract_type;
        }
  | "BinaryExpr" ->
      Binop
        {
          sym = json |> member "operator" |> to_string |> binop_of_string;
          frst = of_json (member "left" json);
          scnd = of_json (member "right" json);
        }
  | "UnaryNegation" ->
      Unop { sym = Negate; frst = of_json (member "expr" json) }
  | "UnaryNot" -> Unop { sym = LogicalNot; frst = of_json (member "expr" json) }
  | "IdentExpr" -> Nam (member "name" json |> to_string)
  | "BorrowExpr" ->
      Borrow
        {
          is_mutable = json |> member "isMutable" |> to_bool;
          expr = member "expr" json |> of_json;
        }
  | "DerefExpr" -> Deref (member "expr" json |> of_json)
  | "FnDecl" ->
      let sym = json |> member "name" |> to_string in
      let prms =
        json |> member "params" |> to_list
        |> List.map (fun p ->
               let name = p |> member "name" |> to_string in
               let typ = p |> member "paramType" |> extract_type in
               let is_mutable = p |> member "isMutable" |> to_bool in
               (name, (typ, is_mutable)))
      in
      let body = json |> member "body" |> of_json in
      let ret_type = json |> member "returnType" |> extract_type in
      let prms_type = List.map (fun (_, typ) -> typ) prms in
      let prm_names = List.map (fun (name, _) -> name) prms in
      Fun
        {
          sym;
          prms = prm_names;
          body;
          declared_type = TFunction { ret = ret_type; prms = prms_type };
        }
  | "WhileLoop" ->
      While
        {
          pred = json |> member "condition" |> of_json;
          body = json |> member "body" |> of_json;
        }
  | "ReturnExpr" -> Ret (json |> member "expr" |> of_json)
  | "FunctionCall" ->

      let fun_nam = Nam (json |> member "name" |> to_string) in
      let args = json |> member "args" |> to_list |> List.map of_json in
      App { fun_nam; args }
  | "AssignmentStmt" ->
      Assign
        {
          sym = json |> member "name" |> to_string;
          expr = json |> member "value" |> of_json;
        }
  | "IfExpr" ->
      Cond
        {
          pred = json |> member "condition" |> of_json;
          cons = json |> member "thenBranch" |> of_json;
          alt = json |> member "elseBranch" |> of_json;
        }
  | "MacroCall" ->
      let name = json |> member "name" |> to_string in
      let args = json |> member "args" |> to_list |> List.map of_json in
      App { fun_nam = Nam name; args }
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
  | Let { sym; expr; _ } -> Let { sym; expr = strip_types expr }
  | Const { sym; expr; _ } -> Const { sym; expr = strip_types expr }
  | Assign { sym; expr } -> Assign { sym; expr = strip_types expr }
  | Binop { sym; frst; scnd } ->
      Binop { sym; frst = strip_types frst; scnd = strip_types scnd }
  | Unop { sym; frst } -> Unop { sym; frst = strip_types frst }
  | Fun { sym; prms; body; _ } -> Fun { sym; prms; body = strip_types body }
  | Ret expr -> Ret (strip_types expr)
  | App { fun_nam; args } ->
      App { fun_nam = strip_types fun_nam; args = List.map strip_types args }
  | Borrow { expr; _ } -> Borrow { expr = strip_types expr }
  | Deref value -> Deref (strip_types value)
