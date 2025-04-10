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
      | None -> failwith "Can't set sym that doesn't exist in sym table")

let extend_scope parent =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; _parent = Some parent }

let create () =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; _parent = None }

let make_err_msg action sym sym_ownership_status =
  Printf.sprintf "Cannot %s %s - already %s" action sym
    (show_ownership_status sym_ownership_status)

let make_borrow_err_msg sym status = make_err_msg "borrow" sym status
let make_move_err_msg sym status = make_err_msg "move" sym status
let make_acc_err_msg sym status = make_err_msg "access" sym status

let rec check_ownership_aux ast_node state : t =
  let is_borrow_valid borrow_status sym_status =
    match (borrow_status, sym_status) with
    | ImmutablyBorrowed, (Owned | ImmutablyBorrowed) | MutablyBorrowed, Owned ->
        true
    | _ -> false
  in

  let handle_variable_borrow sym borrow_status state =
    let maybe_status = lookup_symbol_status sym state in

    match maybe_status with
    | Some status when is_borrow_valid borrow_status status ->
        Hashtbl.replace state.sym_table sym borrow_status;
        state
    | Some status -> failwith (make_borrow_err_msg sym status)
    | None ->
        Hashtbl.replace state.sym_table sym borrow_status;
        state
  in
  let open Ast in
  match ast_node with
  | BorrowExpr { is_mutable; expr = Nam sym } ->
      let borrow_status =
        if is_mutable then MutablyBorrowed else ImmutablyBorrowed
      in
      handle_variable_borrow sym borrow_status state
  | Sequence stmts ->
      let rec check_all stmts cur_state =
        match stmts with
        | [] -> cur_state
        | stmt :: rest ->
            let new_state = check_ownership_aux stmt state in
            check_all rest new_state
      in
      check_all stmts state
  | Nam n -> (
      match lookup_symbol_status n state with
      | Some Moved -> failwith (make_acc_err_msg n Moved)
      | None -> failwith "Unbound name"
      | _ -> state)
  | Let { sym; expr; _ } ->
      (match expr with
      | Nam used_sym -> set_sym_ownership used_sym Moved state
      | _ -> ());
      Hashtbl.replace state.sym_table sym Owned;
      state
  | Block body ->
      let new_state = extend_scope state in
      check_ownership_aux body new_state
  | BorrowExpr _ -> failwith "No support for borrowing of non-variables"
  | _ -> state

let check_ownership ast_node state =
  try
    let _ = check_ownership_aux ast_node state in
    Ok ()
  with
  | Failure e -> Error e
  | exn -> Error (Printexc.to_string exn)
