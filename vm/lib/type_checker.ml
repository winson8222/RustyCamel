type symbol_table = (string, Types.value_type) Hashtbl.t

type t = {
  te : symbol_table;
  parent : t option;
  expected_return : Types.value_type option;
}

let guessed_max_var_count_per_scope = 10

let create () =
  {
    te = Hashtbl.create guessed_max_var_count_per_scope;
    parent = None;
    expected_return = None;
  }

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

let rec type_ast ast_node context =
  let te = context.te in
  let open Ast in
  match ast_node with
  | Literal lit -> (
      match lit with
      | Int _ -> Types.TInt
      | Boolean _ -> Types.TBoolean
      | String _ -> Types.TString
      | Undefined -> Types.TUndefined)
  | Let { declared_type; expr; _ } ->
      let actual_type = type_ast expr context in
      if not (are_types_compatible actual_type declared_type) then
        failwith
          (Printf.sprintf "Type error: expected %s but got %s"
             (Types.show_value_type declared_type)
             (Types.show_value_type actual_type))
      else actual_type
  | Block body ->
      let decls = get_local_decls body in
      extend_te decls te;
      type_ast body context
  | Sequence stmts ->
      let rec check_sequence stmts =
        match stmts with
        | [] -> Types.TUndefined
        | [ stmt ] -> type_ast stmt context
        | Ret expr :: rest ->
            if rest <> [] then
              failwith "Unreachable code after return statement"
            else type_ast (Ret expr) context
        | stmt :: rest ->
            let _ = type_ast stmt context in
            check_sequence rest
      in
      check_sequence stmts
  | Function { sym; body; _ } ->
      let fun_type =
        match lookup_table sym context with
        | Some (Types.TFunction value) -> value
        | _ -> failwith "Expect sym"
      in
      let fun_context = { context with expected_return = Some fun_type.ret } in
      let body_type = type_ast body fun_context in
      if not (are_types_compatible fun_type.ret body_type) then
        failwith
          (Printf.sprintf "Function should return %s but returns %s"
             (Types.show_value_type fun_type.ret)
             (Types.show_value_type body_type))
      else body_type
  | Ret expr -> (
      let ret_type = type_ast expr context in
      match context.expected_return with
      | None -> failwith "Return statement outside of expected return"
      | Some er ->
          if not (are_types_compatible ret_type er) then
            failwith "Return types are not compatible"
          else ret_type)
  | _ -> Types.TInt

let check_type ast_node context =
  try
    let _ = type_ast ast_node context in
    Ok ()
  with Failure msg -> Error msg
