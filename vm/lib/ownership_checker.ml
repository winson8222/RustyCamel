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

let add_builtin_functions (table : symbol_table) =
  let println_type =
    Types.TFunction
      {
        prms = [ (Types.TString, false) ];
        (* println! takes one string, not mutable *)
        ret = Types.TUndefined;
      }
  in
  Hashtbl.replace table "println" { ownership = Owned; typ = println_type }

let create () =
  let sym_table = Hashtbl.create guessed_max_var_count_per_scope in
  add_builtin_functions sym_table;
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
        | Some App -> state
        | _ ->
            let sym_typ = lookup_symbol_type ~sym state in
            if not (Types.is_type_implement_copy sym_typ) then (
              let new_ownership_status =
                borrow_kind_to_ownership_status borrow_kind
              in
              set_sym_ownership_in_cur_frame ~sym
                ~new_status:new_ownership_status ~state;
              state)
            else state)
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
    | _ -> failwith (make_move_err_msg sym sym_status)
  in

  let handle_var_acc sym ~sym_status state =
    match sym_status with
    | Owned -> state
    | _ -> failwith (make_acc_err_msg sym sym_status)
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
          | None -> handle_var_acc sym ~sym_status state)
      | Some bk -> handle_var_borrow sym ~sym_status ~borrow_kind:bk state)
  | Let { sym; expr; declared_type; _ } | Const { sym; expr; declared_type; _ }
    ->
      let new_state =
        check_ownership_aux expr { state with is_in = Some Let }
      in
      Hashtbl.add new_state.sym_table sym
        { ownership = Owned; typ = declared_type };
      new_state
  | Block body -> (
      let new_state = extend_scope state in
      let after_state = check_ownership_aux body new_state in
      match after_state.parent with
      | Some parent -> parent
      | None -> failwith "No parent after extend scope"
      (*TODO Restore parent state after App*))
  | App { args; _ } ->
      let app_state = { state with is_in = Some App } in
      List.fold_left
        (fun acc_state arg -> check_ownership_aux arg acc_state)
        app_state args
  | Fun { prms; body; declared_type; _ } -> (
      match declared_type with
      | Types.TFunction { prms = prms_types; _ } -> (
          let new_state = extend_scope state in
          let combined_prms = List.combine prms prms_types in
          List.iter
            (fun (prm_sym, (prm_type, _)) ->
              Hashtbl.replace new_state.sym_table prm_sym
                { ownership = Owned; typ = prm_type })
            combined_prms;
          let aft_state = check_ownership_aux body new_state in
          match aft_state.parent with
          | Some parent -> parent
          | None -> failwith "Expected parent scope after extend scope")
      | _ -> failwith "Declared type should be a function type")
  | Ret expr -> (
      match expr with
      | Deref _ -> failwith "Cannot move out of a shared reference"
      | non_deref -> (
          match non_deref with
          | Borrow _ ->
              (* guaranteed to be reference to local variable as we've checked its non-param*)
              failwith "Cannot return a reference"
          | nonref -> check_ownership_aux nonref state))
  | Cond { pred; alt; cons } -> (
      let check_same_state (s1 : t) (s2 : t) : bool =
        let print_ownership_diff key info1_opt info2_opt =
          match (info1_opt, info2_opt) with
          | Some info1, Some info2 when info1.ownership <> info2.ownership ->
              Printf.printf "\n%s🔍 Ownership mismatch for variable '%s':%s\n"
                "\027[33m" key "\027[0m";
              Printf.printf "  ├─ Branch 1: %s\n"
                (show_ownership_status info1.ownership);
              Printf.printf "  └─ Branch 2: %s\n"
                (show_ownership_status info2.ownership)
          | Some _, None ->
              Printf.printf
                "\n%s❌ Variable '%s' only exists in first branch%s\n" "\027[31m"
                key "\027[0m"
          | None, Some _ ->
              Printf.printf
                "\n%s❌ Variable '%s' only exists in second branch%s\n"
                "\027[31m" key "\027[0m"
          | _ -> ()
        in

        let keys1 = Hashtbl.to_seq_keys s1.sym_table |> List.of_seq in
        let keys2 = Hashtbl.to_seq_keys s2.sym_table |> List.of_seq in
        let all_keys = List.sort_uniq String.compare (keys1 @ keys2) in

        Printf.printf "\n%s=== Comparing Branch States ===%s\n" "\027[1m"
          "\027[0m";

        let result =
          List.for_all
            (fun key ->
              let info1 = Hashtbl.find_opt s1.sym_table key in
              let info2 = Hashtbl.find_opt s2.sym_table key in
              print_ownership_diff key info1 info2;
              match (info1, info2) with
              | Some info1, Some info2 -> info1.ownership = info2.ownership
              | None, None -> true
              | _ -> false)
            all_keys
        in

        Printf.printf "\n%s=== Branch Comparison %s ===%s\n" "\027[1m"
          (if result then "\027[32mMATCH" else "\027[31mMISMATCH")
          "\027[0m\n";

        result
      in

      let aft_pred_state = check_ownership_aux pred state in
      let alt_state = check_ownership_aux alt aft_pred_state in
      let cons_state = check_ownership_aux cons aft_pred_state in
      match check_same_state alt_state cons_state with
      | true -> alt_state
      | false -> failwith "Both branches should have the same ownership pattern"
      )
  | Literal _ -> state
  | Binop { frst; scnd; _ } ->
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
  | Deref expr -> check_ownership_aux expr state

let check_ownership typed_ast state =
  try
    let _ = check_ownership_aux typed_ast state in
    Ok ()
  with
  | Failure e -> Error e
  | exn -> Error (Printexc.to_string exn)
