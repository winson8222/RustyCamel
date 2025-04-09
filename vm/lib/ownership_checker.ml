type ownership_status = Owned | ImmutablyBorrowed | MutablyBorrowed | Moved
[@@deriving show]

type symbol_table = (string, ownership_status) Hashtbl.t
type t = { sym_table : symbol_table; _parent : t option }

let guessed_max_var_count_per_scope = 10

let rec lookup_symbol sym state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some s -> Some s
  | None -> (
      match state._parent with
      | Some parent -> lookup_symbol sym parent
      | None -> None)

let extend_scope parent =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  { sym_table; _parent = Some parent }

let create () =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  (* Example usage of Owned to avoid unused constructor warning *)
  Hashtbl.add sym_table "example_var" Owned;
  Hashtbl.add sym_table "example_var2" Moved;
  { sym_table; _parent = None }

let rec check_ownership ast_node state =
  let check_borrow_is_valid borrow_status sym_status =
    match (borrow_status, sym_status) with
    | ImmutablyBorrowed, (Owned | ImmutablyBorrowed) | MutablyBorrowed, Owned ->
        Ok ()
    | _ ->
        Error
          "Borrow is invalid as the variable has been moved/borrowed in other \
           places"
  in

  let handle_variable_borrow sym borrow_status =
    match lookup_symbol sym state with
    | Some status -> check_borrow_is_valid borrow_status status
    | None ->
        Hashtbl.replace state.sym_table sym borrow_status;
        Ok ()
  in

  let open Ast in
  match ast_node with
  | BorrowExpr { is_mutable; expr = Variable sym } ->
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
  | Block body ->
      let new_state = extend_scope state in
      let res = check_ownership body new_state in
      res
  | BorrowExpr _ -> failwith "No support for borrowing of non-variables"
  | _ -> Ok ()
