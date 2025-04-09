type ownership_status = Owned | ImmutablyBorrowed | MutablyBorrowed | Moved
[@@deriving show]

type symbol_table = (string, ownership_status) Hashtbl.t
type t = { sym_table : symbol_table; _parent : t option }

let guessed_max_var_count_per_scope = 10

let rec lookup_symbol_status sym state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some s -> Some s
  | None -> (
      match state._parent with
      | Some parent -> lookup_symbol_status sym parent
      | None -> None)

let rec set_sym_ownership sym new_status state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some _ -> Hashtbl.replace state.sym_table sym new_status
  | None -> (
      match state._parent with
      | Some parent -> set_sym_ownership sym new_status parent
      | None -> ())

let extend_scope parent =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; _parent = Some parent }

let create () =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  (* Example usage of Owned to avoid unused constructor warning *)
  Hashtbl.add sym_table "example_var" Owned;
  Hashtbl.add sym_table "example_var2" Moved;
  { sym_table; _parent = None }

let make_borrow_err_msg sym =
  Printf.sprintf "Cannot borrow %s - already moved or borrowed" sym

let rec check_ownership ast_node state =
  let is_borrow_valid borrow_status sym_status =
    match (borrow_status, sym_status) with
    | ImmutablyBorrowed, (Owned | ImmutablyBorrowed) | MutablyBorrowed, Owned ->
        true
    | _ -> false
  in

  let handle_variable_borrow sym borrow_status =
    let status = lookup_symbol_status sym state in

    match status with
    | Some current_status when is_borrow_valid borrow_status current_status ->
        Hashtbl.replace state.sym_table sym borrow_status;
        Ok ()
    | Some _ -> Error (make_borrow_err_msg sym)
    | None ->
        Hashtbl.replace state.sym_table sym borrow_status;
        Ok ()
  in
  let open Ast in
  match ast_node with
  | BorrowExpr { is_mutable; expr = Nam sym } ->
      let borrow_status =
        if is_mutable then MutablyBorrowed else ImmutablyBorrowed
      in
      handle_variable_borrow sym borrow_status
  | Sequence stmts ->
      let rec check_all = function
        | [] -> Ok ()
        | stmt :: rest -> (
            match check_ownership stmt state with
            | Ok () -> check_all rest
            | Error _ as e -> e)
      in
      check_all stmts
  | Nam n -> (
      match lookup_symbol_status n state with
      | Some Moved -> failwith "sym has been moved"
      | None -> failwith "Unbound name"
      | _ -> Ok ())
  | Let { sym; expr; _ } ->
      (match expr with
      | Nam used_sym -> set_sym_ownership used_sym Moved state
      | _ -> ());
      Hashtbl.replace state.sym_table sym Owned;
      Ok ()
  | Block body ->
      let new_state = extend_scope state in
      let res = check_ownership body new_state in
      res
  | BorrowExpr _ -> failwith "No support for borrowing of non-variables"
  | _ -> Ok ()
