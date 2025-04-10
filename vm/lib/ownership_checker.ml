type ownership_status = Owned | ImmutablyBorrowed | MutablyBorrowed | Moved
[@@deriving show]

type symbol_table = (string, ownership_status) Hashtbl.t
type scope = App | Let
type borrow_kind = MutableBorrow | ImmutableBorrow [@@deriving show]

let borrow_kind_to_ownership_status bk =
  match bk with
  | MutableBorrow -> MutablyBorrowed
  | ImmutableBorrow -> ImmutablyBorrowed

type t = {
  sym_table : symbol_table;
  parent : t option;
  is_in : scope option;
  borrow_kind : borrow_kind option;
}

let guessed_max_var_count_per_scope = 10

let rec lookup_symbol_status sym state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some s -> Some s
  | None -> (
      match state.parent with
      | Some parent -> lookup_symbol_status sym parent
      | None -> None)

let rec set_existing_sym_ownership sym new_status state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some _ -> Hashtbl.replace state.sym_table sym new_status
  | None -> (
      match state.parent with
      | Some parent -> set_existing_sym_ownership sym new_status parent
      | None -> failwith "Can't set sym that doesn't exist in sym table")

let extend_scope parent =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; parent = Some parent; is_in = None; borrow_kind = None }

let create () =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; parent = None; is_in = None; borrow_kind = None }

let make_err_msg action sym sym_ownership_status =
  Printf.sprintf "Cannot %s %s - already %s" action sym
    (show_ownership_status sym_ownership_status)

let make_borrow_err_msg sym status = make_err_msg "borrow" sym status
let make_move_err_msg sym status = make_err_msg "move" sym status
let make_acc_err_msg sym status = make_err_msg "access" sym status

let rec check_ownership_aux ast_node state : t =
  let is_borrow_valid ~borrow_kind ~sym_status =
    match (borrow_kind, sym_status) with
    | ImmutableBorrow, (Owned | ImmutablyBorrowed) | MutableBorrow, Owned ->
        true
    | _ -> false
  in

  let handle_variable_borrow sym ~sym_status ~borrow_kind state =
    match is_borrow_valid ~borrow_kind ~sym_status with
    | true -> (
        match state.is_in with
        | Some Let ->
            Hashtbl.replace state.sym_table sym
              (borrow_kind_to_ownership_status borrow_kind);
            state
        | Some App -> state
        | None ->
            (* Rust compiler does this *)
            failwith
              "Warning: unused borrow that must be used. Use let _ = expr")
    | false -> failwith (make_borrow_err_msg sym sym_status)
  in
  let handle_var_acc_or_move sym ~sym_status state =
    match sym_status with
    | Owned -> (
        match state.is_in with
        | Some _ ->
            set_existing_sym_ownership sym Moved state;
            state
        | None -> state (* Simple access, no need to change ownership *))
    | _ ->
        let err_msg_f =
          match state.is_in with
          | Some Let | Some App -> make_move_err_msg
          | _ -> make_acc_err_msg
        in
        failwith (err_msg_f sym sym_status)
  in
  let open Ast in
  match ast_node with
  | BorrowExpr { is_mutable; expr } ->
      let borrow_kind = if is_mutable then MutableBorrow else ImmutableBorrow in
      check_ownership_aux expr { state with borrow_kind = Some borrow_kind }
  | Sequence stmts ->
      let rec check_all stmts cur_state =
        match stmts with
        | [] -> cur_state
        | stmt :: rest ->
            let new_state = check_ownership_aux stmt state in
            check_all rest new_state
      in
      check_all stmts state
  | Nam sym -> (
      (* Only for simple accesses or moves (let assmt) ; otherwise it would have gone to Borrow  *)
      let sym_status =
        match lookup_symbol_status sym state with
        | Some status -> status
        | None -> failwith "Unbound value"
      in

      match state.borrow_kind with
      | None -> handle_var_acc_or_move sym ~sym_status state
      | Some bk -> handle_variable_borrow sym ~sym_status ~borrow_kind:bk state)
  | Let { sym; expr; _ } ->
      let new_state =
        check_ownership_aux expr { state with is_in = Some Let }
      in
      Hashtbl.replace new_state.sym_table sym Owned;
      new_state
  | Block body ->
      let new_state = extend_scope state in
      check_ownership_aux body new_state
  | App { args; _ } ->
      let app_state = { state with is_in = Some App } in
      List.fold_left
        (fun acc_state arg -> check_ownership_aux arg acc_state)
        app_state args
  | _ -> state

let check_ownership ast_node state =
  try
    let _ = check_ownership_aux ast_node state in
    Ok ()
  with
  | Failure e -> Error e
  | exn -> Error (Printexc.to_string exn)
