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
  | Some typ -> Some typ
  | None -> Option.bind state.parent (lookup_table sym)

let is_declaration = function
  | Ast.Let _ | Ast.Const _ | Ast.Fun _ -> true
  | _ -> false

let get_local_decls = function
  | Ast.Sequence stmts ->
      List.filter is_declaration stmts
      |> List.map (function
           | Ast.Let { sym; declared_type; _ }
           | Ast.Const { sym; declared_type; _ }
           | Ast.Fun { sym; declared_type; _ } ->
               (sym, declared_type)
           | _ -> failwith "Invalid declaration node")
  | single -> (
      (* Treat non-sequence as single declaration *)
      match single with
      | Ast.Let { sym; declared_type; _ }
      | Ast.Const { sym; declared_type; _ }
      | Ast.Fun { sym; declared_type; _ } ->
          [ (sym, declared_type) ]
      | _ -> failwith "Invalid declaration node")

let put_decls_in_table decls te =
  List.iter (fun (sym, typ) -> Hashtbl.replace te sym typ) decls

let are_types_compatible = ( = )

let lookup_fun_type sym state : Types.function_type =
  match lookup_table sym state with
  | Some (TFunction value) -> value
  | Some other ->
      failwith ("Expected function type, got: " ^ Types.show_value_type other)
  | None -> failwith ("Function symbol not found: " ^ sym)

let make_type_err_msg declared_type actual_type : string =
  "Expected "
  ^ Types.show_value_type declared_type
  ^ ", got "
  ^ Types.show_value_type actual_type

let rec type_ast ast_node state =
  let open Ast in
  match ast_node with
  | Literal lit -> (
      match lit with
      | Int _ -> Types.TInt
      | Boolean _ -> Types.TBoolean
      | String _ -> Types.TString
      | Undefined -> Types.TUndefined)
  | Let { declared_type; expr; _ } ->
      let actual = type_ast expr state in
      if not (are_types_compatible actual declared_type) then
        failwith (make_type_err_msg declared_type actual)
      else Types.TUndefined
  | Block body ->
      let decls = get_local_decls body in
      let new_state = extend_env state in
      put_decls_in_table decls new_state.te;
      type_ast body new_state
  | Sequence stmts ->
      let rec eval = function
        | [] -> Types.TUndefined
        | [ (Ret _ as stmt) ] -> type_ast stmt state
        | [ last ] -> type_ast last state
        | Ret _ :: _ -> failwith "Unreachable code after return"
        | stmt :: rest ->
            let _ = type_ast stmt state in
            eval rest
      in
      eval stmts
  | Fun { body; declared_type; prms; _ } -> (
      match declared_type with
      | TFunction { ret; prms = param_types } ->
          if List.length prms <> List.length param_types then
            failwith "Mismatched parameters and types";
          let param_decls = List.combine prms param_types in
          let extended_state = extend_env state in
          put_decls_in_table param_decls extended_state.te;
          let fun_state = { extended_state with expected_return = Some ret } in
          let actual_ret = type_ast body fun_state in
          if not (are_types_compatible actual_ret ret) then
            failwith
              ("Function should return " ^ Types.show_value_type ret
             ^ " but returns "
              ^ Types.show_value_type actual_ret)
          else declared_type
      | _ -> failwith "Expected function type in Fun declaration")
  | Ret { expr; _ } -> (
      let ret_type = type_ast expr state in
      match state.expected_return with
      | None -> failwith "Return statement outside of function"
      | Some expected ->
          if not (are_types_compatible ret_type expected) then
            failwith "Return type mismatch"
          else ret_type)
  | Binop { frst; scnd; _ } ->
      let t1 = type_ast frst state in
      let t2 = type_ast scnd state in
      if not (are_types_compatible t1 t2) then
        failwith "Binary operands have incompatible types"
      else t1
  | App { fun_nam; args } ->
      let fun_sym =
        match fun_nam with
        | Nam n -> n
        | _ -> failwith "Expected function name (Nam)"
      in
      let fun_type = lookup_fun_type fun_sym state in
      let arg_types = List.map (fun a -> type_ast a state) args in
      let prm_types = fun_type.prms in
      if List.length prm_types <> List.length arg_types then
        failwith "Mismatched number of arguments";
      List.iter2
        (fun expected actual ->
          if not (are_types_compatible expected actual) then
            failwith "Argument type mismatch")
        prm_types arg_types;
      fun_type.ret
  | _ -> TInt (* fallback/default case; could be improved *)

let check_type ast_node state =
  try
    let _ = type_ast ast_node state in
    Ok ()
  with Failure msg -> Error msg
