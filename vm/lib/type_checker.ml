type symbol_table = (string, Types.value_type) Hashtbl.t
type t = { symbols : symbol_table; parent : t }

let guessed_max_var_count_per_scope = 10

let create parent =
  { symbols = Hashtbl.create guessed_max_var_count_per_scope; parent }

let set_symbol state sym value = ()

let get_symbol state sym =
  let rec helper cur_state =
    match Hashtbl.find_opt cur_state.symbols sym with
    | None -> helper cur_state.parent
    | Some value -> value
  in
  helper state

let handle_check_instr instr =
  match instr with Ast.Let { sym } -> Ok () | _ -> Ok ()

let check_types state instrs =
  let rec helper_check_types cur_state cur_instrs =
    match cur_instrs with
    | [] -> Ok ()
    | instr :: tl -> (
        match handle_check_instr instr with
        | Ok () ->
            let new_state = cur_state in
            helper_check_types new_state tl
        | Error e -> Error e)
  in
  helper_check_types state instrs
