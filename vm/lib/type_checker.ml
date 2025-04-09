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

let is_declaration node =
  let open Ast in
  match node with Let _ | Const _ | Fun _ -> true | _ -> false

let get_local_decls block_body =
  let open Ast in
  let get_single_decl node =
    match node with
    | Let { sym; declared_type; _ }
    | Const { sym; declared_type; _ }
    | Fun { sym; declared_type; _ } ->
        (sym, declared_type)
    | _ -> failwith "No declaration for this type"
  in
  match block_body with
  | Sequence stmts ->
      List.filter (fun stmt -> is_declaration stmt) stmts
      |> List.map (fun node -> get_single_decl node)
  | _ -> [ get_single_decl block_body ]

let rec extend_te decls te =
  match decls with
  | hd :: tl ->
      let sym, declared_type = hd in
      Hashtbl.replace te sym declared_type;
      extend_te tl te
  | [] -> ()

let are_types_compatible t1 t2 = t1 = t2

let lookup_fun_type sym state =
  match lookup_table sym state with
  | Some (TFunction value) -> value
  | Some other ->
      failwith
        (Printf.sprintf "Unexpected type: %s" (Types.show_value_type other))
  | None -> failwith "No sym found in type env"

let rec type_ast ast_node context =
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
      Printf.printf "decls: %s"
        (String.concat ", "
           (List.map
              (fun (sym, typ) ->
                Printf.sprintf "(%s, %s)" sym (Types.show_value_type typ))
              decls));
      extend_te decls context.te;
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
  | Fun { sym; body; _ } ->
      let fun_type = lookup_fun_type sym context in
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
  | Binop { frst; scnd; _ } ->
      (*TODO: Add sym is valid for operand type*)
      let frst_type = type_ast frst context in
      let scnd_type = type_ast scnd context in
      if not (are_types_compatible frst_type scnd_type) then
        failwith "Operand types for binop expression are not compatible"
      else frst_type
  | App { fun_nam; args } ->
      let fun_sym =
        match fun_nam with
        | Nam n -> n
        | _ -> failwith "Fun should be of type Nam"
      in
      let fun_type = lookup_fun_type fun_sym context in
      let declared_prm_types = fun_type.prms in
      let args_types = List.map (fun arg -> type_ast arg context) args in

      let rec check_all_types prms args =
        match (prms, args) with
        | [], [] -> ()
        | prm :: rest_prms, arg :: rest_args ->
            if not (are_types_compatible prm arg) then
              failwith "Types of arg and parm are not compatible"
            else check_all_types rest_prms rest_args
        | _ -> failwith "mismatched length between args and parms"
      in
      check_all_types declared_prm_types args_types;
      fun_type.ret
  | _ -> Types.TInt

let check_type ast_node context =
  try
    let _ = type_ast ast_node context in
    Ok ()
  with Failure msg -> Error msg
