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
  | App of ast_node
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
  | "fun" ->
      let sym = json |> member "sym" |> to_string in
      let prms = json |> member "prms" |> to_list |> List.map (fun p -> 
        {
          name = p |> member "name" |> to_string;
          param_type = {
            type_name = p |> member "paramType" |> member "type" |> to_string;
            ownership = p |> member "paramType" |> member "ownership" |> to_string;
          };
        }) in
      let ret_type = match json |> member "retType" with
        | `Null -> None
        | ret_type_json -> Some {
            type_name = ret_type_json |> member "type" |> to_string;
            ownership = ret_type_json |> member "ownership" |> to_string;
          }
      in
      let body = json |> member "body" |> of_json in
      Fun { sym; prms; ret_type; body }
  | "lam" ->
      let prms = json |> member "prms" |> to_list |> List.map (fun p -> 
        {
          name = p |> member "name" |> to_string;
          param_type = {
            type_name = p |> member "paramType" |> member "type" |> to_string;
            ownership = p |> member "paramType" |> member "ownership" |> to_string;
          };
        }) in
      let body = json |> member "body" |> of_json in
      Lam { prms; body }
  | "ret" -> Ret (json |> member "expr" |> of_json)
  | tag -> failwith ("Unknown tag: " ^ tag)
