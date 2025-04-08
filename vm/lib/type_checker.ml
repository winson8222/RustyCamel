type symbol_table = (string, Types.value_type) Hashtbl.t
type t = { te : symbol_table; parent : t option }

let guessed_max_var_count_per_scope = 10

let create () =
  let empty_te = Hashtbl.create guessed_max_var_count_per_scope in
  { te = empty_te; parent = None }

let rec lookup_table sym state =
  match Hashtbl.find_opt state.te sym with
  | None -> (
      match state.parent with None -> None | Some p -> lookup_table sym p)
  | Some typ -> Some typ

let is_declaration node = match node with Ast.Let _ -> true | _ -> false

let get_local_decls block_body =
  let open Ast in
  match block_body with
  | Let { sym; declared_type; _ }
  | Const { sym; declared_type; _ }
  | Function { sym; declared_type; _ } ->
      [ (sym, declared_type) ]
  | Sequence stmts ->
      List.filter (fun stmt -> is_declaration stmt) stmts
      |> List.map (fun node ->
             match node with
             | Let { sym; declared_type; _ } -> (sym, declared_type)
             | _ -> failwith "unrecognized")
  | _ -> []

let rec extend_te decls te =
  match decls with
  | hd :: tl ->
      let sym, declared_type = hd in
      Hashtbl.replace te sym declared_type;
      extend_te tl te
  | [] -> ()

let are_types_compatible t1 t2 = t1 = t2

let rec type_ast ast_node state =
  let te = state.te in
  let open Ast in
  match ast_node with
  | Literal lit -> (
      match lit with
      | Int _ -> Types.TInt
      | Boolean _ -> Types.TBoolean
      | String _ -> Types.TString
      | Undefined -> Types.TUndefined)
  | Let { declared_type; expr; _ } ->
      let actual_type = type_ast expr state in
      if not (are_types_compatible actual_type declared_type) then
        failwith
          (Printf.sprintf "Type error: expected %s but got %s"
             (Types.show_value_type declared_type)
             (Types.show_value_type actual_type))
      else actual_type
  | Block body ->
      let decls = get_local_decls body in
      extend_te decls te;
      type_ast body state
  | Function { sym; body; _ } ->
      let fun_type =
        match lookup_table sym state with
        | Some (Types.TFunction value) -> value
        | _ -> failwith "Expect sym"
      in
      let body_type = type_ast body state in
      if not (are_types_compatible fun_type.ret body_type) then
        failwith "type err"
      else body_type
  | _ -> Types.TInt

let check_type ast_node state =
  try
    let _ = type_ast ast_node state in
    Ok ()
  with Failure msg -> Error msg
