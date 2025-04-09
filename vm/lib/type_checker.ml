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

(* Adds new empty frame*)
let extend_env (state : t) =
  {
    te = Hashtbl.create guessed_max_var_count_per_scope;
    parent = Some state;
    expected_return = None;
  }

let rec lookup_table sym state =
  match Hashtbl.find_opt state.te sym with
  | None -> (
      match state.parent with None -> None | Some p -> lookup_table sym p)
  | Some typ -> Some typ

let rec lookup_fun sym state =
  match lookup_table sym state with
  | Some (TFunction value) -> value
  | None -> failwith "No function found with the given sym in type env"
  | Some _ -> failwith "Function type is in an unexpected format"

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

let rec put_decls_in_table decls te =
  match decls with
  | hd :: tl ->
      let sym, declared_type = hd in
      Hashtbl.replace te sym declared_type;
      put_decls_in_table tl te
  | [] -> ()

let are_types_compatible t1 t2 = t1 = t2

let lookup_fun_type sym state =
  match lookup_table sym state with
  | Some (TFunction value) -> value
  | Some other ->
      failwith
        (Printf.sprintf "Unexpected type: %s" (Types.show_value_type other))
  | None -> failwith "No sym found in type env"

let rec type_ast (ast_node : Ast.typed_ast) (state : t) =
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
      Printf.printf "decls: %s"
        (String.concat ", "
           (List.map
              (fun (sym, typ) ->
                Printf.sprintf "(%s, %s)" sym (Types.show_value_type typ))
              decls));
      let new_state = extend_env state in
      put_decls_in_table decls new_state.te;
      type_ast body new_state
  | Sequence stmts ->
      let rec check_sequence stmts =
        match stmts with
        | [] -> Types.TUndefined
        | [ stmt ] -> type_ast stmt state
        | Ret expr :: rest ->
            if rest <> [] then
              failwith "Unreachable code after return statement"
            else type_ast (Ret expr) state
        | stmt :: rest ->
            let _ = type_ast stmt state in
            check_sequence rest
      in
      check_sequence stmts
  | Fun { body; declared_type; prms; _ } ->
      let fun_type =
        match declared_type with
        | TFunction value -> value
        | _ -> failwith "unexpected. Should be a function"
      in
      let param_declarations =
        try List.map2 (fun name typ -> (name, typ)) prms fun_type.prms
        with Invalid_argument _ ->
          failwith "Mismatched number of parameters and type declarations"
      in
      let new_state = extend_env state in
      put_decls_in_table param_declarations new_state.te;
      let fun_state = { new_state with expected_return = Some fun_type.ret } in
      let body_type = type_ast body fun_state in
      if not (are_types_compatible fun_type.ret body_type) then
        failwith
          (Printf.sprintf "Function should return %s but returns %s"
             (Types.show_value_type fun_type.ret)
             (Types.show_value_type body_type))
      else body_type
  | Ret expr -> (
      let ret_type = type_ast expr state in
      match state.expected_return with
      | None -> failwith "Return statement outside of expected return"
      | Some er ->
          if not (are_types_compatible ret_type er) then
            failwith "Return types are not compatible"
          else ret_type)
  | Binop { frst; scnd; _ } ->
      (*TODO: Add sym is valid for operand type*)
      let frst_type = type_ast frst state in
      let scnd_type = type_ast scnd state in
      if not (are_types_compatible frst_type scnd_type) then
        failwith "Operand types for binop expression are not compatible"
      else frst_type
  | App { fun_nam; args } ->
      let fun_sym =
        match fun_nam with
        | Nam n -> n
        | _ -> failwith "Fun should be of type Nam"
      in
      let fun_type = lookup_fun_type fun_sym state in
      let declared_prm_types = fun_type.prms in
      let args_types = List.map (fun arg -> type_ast arg state) args in

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

let check_type ast_node state =
  try
    let _ = type_ast ast_node state in
    Ok ()
  with Failure msg -> Error msg
