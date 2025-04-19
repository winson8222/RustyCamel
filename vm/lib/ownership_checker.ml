type ownership_status = Owned | ImmutablyBorrowed | MutablyBorrowed | Moved
[@@deriving show]

type symbol_info = { ownership : ownership_status; typ : Types.value_type }
[@@deriving show]

type symbol_table = (string, symbol_info) Hashtbl.t
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
  | Some info -> Some info.ownership
  | None -> Option.bind state.parent (lookup_symbol_status sym)

let rec lookup_symbol_type ~sym state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some info -> info.typ
  | None -> (
      match state.parent with
      | None -> failwith "Sym not found in table"
      | Some parent -> lookup_symbol_type ~sym parent)

let rec set_existing_sym_ownership_in_lowest_frame sym new_status state =
  match Hashtbl.find_opt state.sym_table sym with
  | Some info ->
      Hashtbl.replace state.sym_table sym { info with ownership = new_status }
  | None -> (
      match state.parent with
      | Some parent ->
          set_existing_sym_ownership_in_lowest_frame sym new_status parent
      | None -> failwith "Can't set sym that doesn't exist in sym table")

let set_sym_ownership_in_cur_frame ~sym ~new_status ~state =
  let declared_type = lookup_symbol_type ~sym state in
  Hashtbl.replace state.sym_table sym
    { ownership = new_status; typ = declared_type }

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

let rec check_ownership_aux (typed_ast : Ast.typed_ast) state : t =
  let is_borrow_valid ~borrow_kind ~sym_status =
    match (borrow_kind, sym_status) with
    | ImmutableBorrow, (Owned | ImmutablyBorrowed) | MutableBorrow, Owned ->
        true
    | _ -> false
  in

  let handle_var_borrow sym ~sym_status ~borrow_kind state =
    match is_borrow_valid ~borrow_kind ~sym_status with
    | true -> (
        match state.is_in with
        | Some Let ->
            let sym_typ = lookup_symbol_type ~sym state in
            if not (Types.is_type_implement_copy sym_typ) then (
              let new_ownership_status =
                borrow_kind_to_ownership_status borrow_kind
              in
              set_sym_ownership_in_cur_frame ~sym
                ~new_status:new_ownership_status ~state;
              state)
            else state
        | Some App -> state
        | None ->
            (* Rust compiler does this *)
            failwith
              "Warning: unused borrow that must be used. Use let _ = expr")
    | false -> failwith (make_borrow_err_msg sym sym_status)
  in
  let handle_var_move sym ~sym_status state =
    match sym_status with
    | Owned -> 
        let sym_typ = lookup_symbol_type ~sym state in
        if not (Types.is_type_implement_copy sym_typ) then (
          set_existing_sym_ownership_in_lowest_frame sym Moved state;
          state)
        else state
    | _ -> failwith (make_move_err_msg sym sym_status) in

    let handle_var_acc sym ~sym_status state = 
      match sym_status with
      | Owned -> state
      | _ ->failwith (make_acc_err_msg sym sym_status)

  in
  let open Ast in
  match typed_ast with
  | Borrow { is_mutable; expr } ->
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
      let sym_status =
        match lookup_symbol_status sym state with
        | Some status -> status
        | None -> failwith "Unbound value"
      in

      match state.borrow_kind with
      | None -> (
        match state.is_in with 
        | Some _ -> handle_var_move sym ~sym_status state 
        | None -> handle_var_acc sym ~sym_status state
      ) 
      | Some bk -> handle_var_borrow sym ~sym_status ~borrow_kind:bk state)
  | Let { sym; expr; declared_type; _ } ->
      let new_state =
        check_ownership_aux expr { state with is_in = Some Let }
      in
      Hashtbl.add new_state.sym_table sym
        { ownership = Owned; typ = declared_type };
      new_state
  | Block body ->
      let new_state = extend_scope state in
      check_ownership_aux body new_state
  | App { args; _ } ->
      let app_state = { state with is_in = Some App } in
      List.fold_left
        (fun acc_state arg -> check_ownership_aux arg acc_state)
        app_state args
  | Fun { prms; body; declared_type; _ } ->
      let new_state = extend_scope state in
      List.iter
        (fun prm_sym ->
          Hashtbl.replace new_state.sym_table prm_sym
            { ownership = Owned; typ = declared_type })
        prms;
      check_ownership_aux body new_state
  | Ret expr -> check_ownership_aux expr state
  | Cond { pred; alt; cons} -> 
    check_ownership_aux pred state |> check_ownership_aux alt |> check_ownership_aux cons
  | Literal _ -> state
  | Binop {  frst; scnd; _ }-> 
    check_ownership_aux frst state |> check_ownership_aux scnd
  | Unop { sym = _; frst } ->
      (* Unary operations like -x or !x just check the operand's ownership *)
      check_ownership_aux frst state
  | Assign { sym; expr } ->
    (* Ensure the symbol exists and is assignable *)
    let sym_status =
      match lookup_symbol_status sym state with
      | Some status -> status
      | None -> failwith ("Cannot assign to undeclared variable: " ^ sym)
    in
    let _ = handle_var_acc sym ~sym_status state in
    check_ownership_aux expr state 
  | While { pred; body } ->
    let _ = check_ownership_aux pred state in
    let new_state = extend_scope state in
    check_ownership_aux body new_state
  | other -> failwith ("Unsupported ast node in ownership checking: " ^ (show_typed_ast other))

let check_ownership typed_ast state =
  Printf.printf "=========Starting ownership checking=========";
  try
    let _ = check_ownership_aux typed_ast state in
    Ok ()
  with
  | Failure e -> Error e
  | exn -> Error (Printexc.to_string exn)
