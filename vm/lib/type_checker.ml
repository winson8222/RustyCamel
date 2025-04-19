
type tc_type =
  | Value of Types.value_type
  | Ret of Types.value_type
[@@deriving show]

type symbol_table = (string, (Types.value_type * bool)) Hashtbl.t

type t = {
  te : symbol_table;
  parent : t option;
}

let guessed_max_var_count_per_scope = 10

let create () =
  let state = {
    te = Hashtbl.create guessed_max_var_count_per_scope;
    parent = None;
  } in
  let add_builtin_functions state =
    let println_type =
      Types.TFunction {
        prms = [ (Types.TString, false) ];  (* println! takes one string, not mutable *)
        ret = Types.TUndefined;
      }
    in
    Hashtbl.replace state.te "println" (println_type, false)

    (* add more here*)
  in
  add_builtin_functions state;
  state

let extend_env (state : t) =
  {
    te = Hashtbl.create guessed_max_var_count_per_scope;
    parent = Some state;
  }

let rec lookup_sym sym state =
  match Hashtbl.find_opt state.te sym with
  | Some (typ, is_mutable) -> Some (typ, is_mutable)
  | None -> Option.bind state.parent (lookup_sym sym)

let is_declaration = function
  | Ast.Let _ | Ast.Const _ | Ast.Fun _ -> true
  | _ -> false

let get_local_decls = function
  | Ast.Sequence stmts ->
      List.filter is_declaration stmts
      |> List.map (function
           | Ast.Let { sym; declared_type; is_mutable; _ } ->
               (sym, (declared_type, is_mutable))
           | Ast.Const { sym; declared_type; _ } ->
               (sym, (declared_type, false))
           | Ast.Fun { sym; declared_type; _ } ->
               (sym, (declared_type, false))
           | _ -> failwith "Invalid declaration node")
  | single -> (
      match single with
      | Ast.Let { sym; declared_type; is_mutable; _ } ->
          [ (sym, (declared_type, is_mutable)) ]
      | Ast.Const { sym; declared_type; _ } ->
          [ (sym, (declared_type, false)) ]
      | Ast.Fun { sym; declared_type; _ } ->
          [ (sym, (declared_type, false)) ]
      | _ -> failwith "Invalid declaration node")

let put_decls_in_table decls te =
  List.iter (fun (sym, (typ, is_mutable)) -> Hashtbl.replace te sym (typ, is_mutable)) decls

let are_types_compatible = ( = )

let lookup_fun_type sym state : Types.function_type =
  match lookup_sym sym state with
  | Some (Types.TFunction value, _) -> value
  | Some (other, _) ->
      failwith ("Expected function type, got: " ^ Types.show_value_type other)
  | None -> failwith ("Function symbol not found: " ^ sym)

let make_type_err_msg declared_type actual_type =
  "Expected "
  ^ Types.show_value_type declared_type
  ^ ", got "
  ^ Types.show_value_type actual_type

let is_binop_type_compatible sym t1 t2 =
  let open Ast in
  match sym with
  | Add | Subtract | Multiply | Divide -> (
      match (t1, t2) with
      | Types.TInt, Types.TInt | Types.TFloat, Types.TFloat -> true
      | _ -> false
    )
  | LessThan | LessThanEqual | GreaterThan | GreaterThanEqual -> (
      match (t1, t2) with
      | Types.TInt, Types.TInt | Types.TFloat, Types.TFloat -> true
      | _ -> false
    )
  | Equal | NotEqual -> (
      match (t1, t2) with
      | Types.TInt, Types.TInt | Types.TFloat, Types.TFloat -> true
      | Types.TString, Types.TString -> true
      | Types.TBoolean, Types.TBoolean -> true
      | Types.TUndefined, Types.TUndefined -> true
      | _ -> false
    )

let make_deref_non_ref_val_msg actual_type =
  "Cannot dereference expression of type " ^ Types.show_value_type actual_type

let rec type_ast ast_node state : tc_type =
  let open Ast in
  match ast_node with
  | Literal lit ->
      let typ = match lit with
        | Int _ -> Types.TInt
        | Float _ -> Types.TFloat
        | Boolean _ -> Types.TBoolean
        | String _ -> Types.TString
        | Undefined -> Types.TUndefined
      in
      Value typ

  | Nam sym -> (
      match lookup_sym sym state with
      | Some (t, _) -> Value t
      | None -> failwith ("Unbound symbol: " ^ sym)
    )

  | Let { declared_type; expr; _ } -> 
      let expr_type = type_ast expr state in
      (match expr_type with
       | Value actual ->
           if not (are_types_compatible actual declared_type) then
             failwith (make_type_err_msg declared_type actual)
           else Value Types.TUndefined
       | Ret _ -> failwith "Return not allowed in expression")

  | Block body ->
      let decls = get_local_decls body in
      let new_state = extend_env state in
      put_decls_in_table decls new_state.te;
      type_ast body new_state

  | Sequence stmts ->
      let rec eval = function
        | [] -> Value Types.TUndefined
        | [ last ] -> type_ast last state
        | Ret _ :: _ -> failwith "Unreachable code after return"
        | stmt :: rest -> (
            match type_ast stmt state with
            | Ret t -> Ret t
            | Value _ -> eval rest
          )
      in
      eval stmts

  | Fun { body; declared_type; prms; _ } -> (
      match declared_type with
      | Types.TFunction { ret; prms=param_types } ->
          if List.length prms <> List.length param_types then
            failwith "Mismatched parameters and types";
          let param_decls = List.map2 (fun name prm_type -> (name, prm_type)) prms param_types in
          let extended_state = extend_env state in
          put_decls_in_table param_decls extended_state.te;
          let body_tc = type_ast body extended_state in
          (match body_tc with
          | Ret actual_ret ->
              if are_types_compatible actual_ret ret then declared_type
              else
                failwith
                  ("Function should return " ^ Types.show_value_type ret
                  ^ " but returns " ^ Types.show_value_type actual_ret)
          | Value _ ->
              if are_types_compatible ret Types.TUndefined then
                declared_type
              else
                failwith
                  ("Missing return in function body. Declared return type: "
                  ^ Types.show_value_type ret))
          |> fun typ -> Value typ
      | _ -> failwith "Expected function type in Fun declaration"
    )

  | Ret expr -> (
      match type_ast expr state with
      | Value v -> Ret v
      | Ret _ -> failwith "Nested return not allowed"
    )

  | Binop { frst; scnd; sym } ->
      let t1 = type_ast frst state in
      let t2 = type_ast scnd state in

      (*print out the 2 types*)
      Printf.printf "t1: %s\n" (show_tc_type t1);
      Printf.printf "t2: %s\n" (show_tc_type t2);
      (match (t1, t2) with
       | Value v1, Value v2 ->
           if is_binop_type_compatible sym v1 v2 then (
            match sym with 
            | LessThan | LessThanEqual | GreaterThan | GreaterThanEqual | Equal | NotEqual -> Value Types.TBoolean 
            | _ -> Value v1
           )
           else failwith "Binary operands have incompatible types"
       | _ -> failwith "Return not allowed in binary operation")
  | App { fun_nam; args } ->
      let fun_sym =
        match fun_nam with
        | Nam n -> n
        | _ -> failwith "Expected function name (Nam)"
      in
      if Builtins.is_builtin_name fun_sym then (
        let builtin_id = Builtins.get_builtin_id_by_name fun_sym in
        let arg_types = List.map (fun a -> 
          match type_ast a state with
          | Value t -> t
          | Ret _ -> failwith "Return not allowed in argument"
        ) args in
        if not (Builtins.validate_builtin_args builtin_id arg_types) then
          failwith "Invalid argument types for builtin function";
        Value (Builtins.get_builtin_ret_type builtin_id)
      ) else (
        let fun_type = lookup_fun_type fun_sym state in
        let arg_types = List.map (fun a -> type_ast a state) args in
        let prm_types = fun_type.prms in
        if List.length prm_types <> List.length arg_types then
          failwith "Mismatched number of arguments";
        List.iter2
          (fun (expected_type, _) actual ->
             match actual with
             | Value a ->
                 if not (are_types_compatible expected_type a) then
                   failwith "Argument type mismatch"
             | Ret _ -> failwith "Return not allowed in argument")
          prm_types arg_types;
        Value fun_type.ret
      )
  | Unop { sym; frst } -> (
        match type_ast frst state with
        | Value t -> (
            match sym with
            | Negate -> (
                match t with
                | Types.TInt | Types.TFloat -> Value t
                | _ ->
                    failwith
                      ("Unary negation (-) not valid for type: "
                      ^ Types.show_value_type t)
              )
            | LogicalNot -> (
                match t with
                | Types.TBoolean -> Value Types.TBoolean
                | _ ->
                    failwith
                      ("Logical not (!) not valid for type: "
                      ^ Types.show_value_type t)
              )
          )
        | Ret _ -> failwith "Return not allowed in unary operation"
      )
  | Deref expr -> (
      match type_ast expr state with
      | Value (Types.TRef { base; _ }) -> Value base
      | Value other -> failwith (make_deref_non_ref_val_msg other)
      | Ret _ -> failwith "Return not allowed in deref"
    )

  | Borrow { is_mutable; expr } ->
      (match type_ast expr state with
       | Value base -> Value (Types.TRef { is_mutable; base })
       | Ret _ -> failwith "Return not allowed in borrow")

  | Cond { pred; cons; alt } ->
      (match type_ast pred state with
       | Value Types.TBoolean -> ()
       | Value other -> failwith ("Condition must be boolean. Actual type: " ^ (Types.show_value_type other))
       | Ret _ -> failwith "Return not allowed in condition predicate");
      let cons_t = type_ast cons state in
      let alt_t = type_ast alt state in
      (match (cons_t, alt_t) with
      | Ret t1, Ret t2 ->
          if are_types_compatible t1 t2 then Ret t1
          else failwith "Branches of if-else return incompatible types"
      | Value v1, Value v2 ->
          if are_types_compatible v1 v2 then Value v1
          else failwith "Branches of if-else return incompatible types"
      | Ret _, Value _ | Value _, Ret _ ->
          failwith "Only one branch returns in conditional")
  | Assign { sym; expr } -> (
    (* check if sym is mutable *)
    let _= match lookup_sym sym state with
      | Some (Types.TRef { is_mutable; _ }, _) ->
        if is_mutable then ()
        else failwith "Cannot assign to a non-mutable reference"
     (* for other types, check if they are mutable *)
     | Some (other, is_mutable) ->
        if is_mutable then ()
        else failwith ("Expected mutable reference type, got: " ^ (Types.show_value_type other))
     | None -> failwith ("Unbound symbol for assignment: " ^ sym)
    in
    match lookup_sym sym state with
    | Some (typ, _) -> (
        match type_ast expr state with
        | Value actual_type ->
            if are_types_compatible typ actual_type then
              Value Types.TUndefined
            else
              failwith (make_type_err_msg typ actual_type)
        | Ret _ -> failwith "Return not allowed in assignment expression"
      )
    | None -> failwith ("Unbound symbol for assignment: " ^ sym)
  )

  | While { pred; body } ->
    (* Check the condition type *)
    (match type_ast pred state with
     | Value Types.TBoolean -> ()
     | Value other ->
         failwith
           ("Condition of while loop must be boolean. Got: "
           ^ Types.show_value_type other)
     | Ret _ -> failwith "Return not allowed in while condition");
    (* Type check body in a new scope *)
    let new_state = extend_env state in
    let _ = type_ast body new_state in
    Value Types.TUndefined
  | _ -> failwith "Type checking not supported"

let check_type ast_node state =
  Printf.printf "======Starting type checking=======\n";
  try
    let _ = type_ast ast_node state in
    Ok ()
  with Failure msg -> Error msg