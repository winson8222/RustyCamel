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

type ownership_display = {
  color: string;
  symbol: string;
  label: string;
}

let ownership_display = function
  | Owned -> 
      { color = "\027[32m"; (* Green *)
        symbol = "✦";
        label = "OWNED" }
  | Moved -> 
      { color = "\027[31m"; (* Red *)
        symbol = "✗";
        label = "MOVED" }
  | ImmutablyBorrowed -> 
      { color = "\027[34m"; (* Blue *)
        symbol = "⟲";
        label = "IMMUT BORROW" }
  | MutablyBorrowed -> 
      { color = "\027[35m"; (* Magenta *)
        symbol = "⟳";
        label = "MUT BORROW" }

let reset_color = "\027[0m"
let bold = "\027[1m"
let dim = "\027[2m"

let visualize_ownership_state state =
  let border_top    = "╔════════════════════════════════════════════╗" in
  let border_bottom = "╚════════════════════════════════════════════╝" in
  let border_mid    = "╠════════════════════════════════════════════╣" in

  Printf.printf "\n%s%s%s\n" bold border_top reset_color;
  Printf.printf "%s║     🔍 Ownership Tracker - Memory State     ║%s\n" bold reset_color;
  Printf.printf "%s%s%s\n" dim border_mid reset_color;

  let rec visualize_frame state depth =
    let indent = String.make (depth * 2) ' ' in
    Printf.printf "%s║ %s📦 Scope Level %d%s\n" dim indent depth reset_color;
    
    Hashtbl.iter
      (fun sym info ->
        let display = ownership_display info.ownership in
        Printf.printf "%s║ %s%s├─ %s %s%s%s: %s %s%s\n" 
          dim
          indent
          (if depth > 0 then "  " else "")
          display.symbol
          display.color
          sym
          reset_color
          display.label
          (match state.is_in with
           | Some App -> "📞 [in fn call]"
           | Some Let -> "📝 [in let]"
           | None -> "")
          (dim ^ "(" ^ Types.show_value_type info.typ ^ ")" ^ reset_color))
      state.sym_table;

    match state.parent with
    | Some parent -> 
        Printf.printf "%s║%s\n" dim reset_color;
        visualize_frame parent (depth + 1)
    | None -> ()
  in
  
  visualize_frame state 0;
  Printf.printf "%s%s%s\n\n" dim border_bottom reset_color


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
  let handle_var_acc_or_move sym ~sym_status state =
    match sym_status with
    | Owned -> (
        match state.is_in with
        | Some _ ->
            let sym_typ = lookup_symbol_type ~sym state in
            if not (Types.is_type_implement_copy sym_typ) then (
              set_existing_sym_ownership_in_lowest_frame sym Moved state;
              state)
            else state
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
      | None -> handle_var_acc_or_move sym ~sym_status state
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
  | Literal _ -> state
  | _ -> failwith "Unsupported ast node in ownership checking"

let check_ownership typed_ast state =
  Printf.printf "\n%s🚀 Starting Ownership Checker 🚀%s\n" bold reset_color;
  
  try
    Printf.printf "\n%s📊 Initial State:%s\n" bold reset_color;
    visualize_ownership_state state;
    
    let final_state = check_ownership_aux typed_ast state in
    
    Printf.printf "\n%s✨ Final State:%s\n" bold reset_color;
    visualize_ownership_state final_state;
    
    Printf.printf "%s%s✅ Ownership check completed successfully!%s\n" 
      bold "\027[32m" reset_color;
    Ok ()
  with
  | Failure e -> 
      Printf.printf "\n%s%s❌ Error: %s%s\n" 
        bold "\027[31m" e reset_color;
      Error e
  | exn -> Error (Printexc.to_string exn)