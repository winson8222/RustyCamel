type pos_in_env = { frame_index : int; value_index : int } [@@deriving show]

type compiled_instruction =
  | LDC of Value.lit_value
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | BINOP of { sym : string }
  | UNOP of { sym : string }
  | ASSIGN of pos_in_env
  | POP
  | LD of { sym : string; pos : pos_in_env }
  | LDF of { arity : int; addr : int }
  | GOTO of int
  | RESET
  | TAILCALL
  | DONE
[@@deriving show]

(* Compile time state *)
type state = {
  instrs : compiled_instruction list; (* Symbol table with positions *)
  ce : string list list;
  wc : int;
}

(* TODO: Add global compile environment with builtin frames *)
let initial_state = { instrs = []; ce = []; wc = 0 }

let find_index f ls =
  let rec find_index_helper ls f cur_index =
    match ls with
    | [] -> None
    | hd :: tl -> (
        match f hd with
        | true -> Some cur_index
        | false -> find_index_helper tl f (cur_index + 1))
  in
  find_index_helper ls f 0

(** Helper functions *)
let rec scan_for_locals node =
  let open Ast in
  match node with
  | Let { sym; _ } | Const { sym; _ } -> [ sym ]
  | Sequence stmts ->
      List.fold_left (fun acc x -> acc @ scan_for_locals x) [] stmts
  | _ -> []

let get_compile_time_environment_pos sym ce =
  let reversed_ce = List.rev ce in
  let rec helper sym ce cur_frame_index =
    match ce with
    | [] -> failwith "Symbol not found in compile time environment"
    | cur_frame :: tl_frames -> (
        let maybe_sym_index =
          find_index (fun x -> String.equal x sym) cur_frame
        in
        match maybe_sym_index with
        | Some sym_index ->
            { frame_index = cur_frame_index; value_index = sym_index }
        | None -> helper sym tl_frames (cur_frame_index + 1))
  in
  helper sym reversed_ce 0

let compile_time_environment_extend frame_vars ce = [ frame_vars ] @ ce

(* Compilation functions *)
let rec compile node state =
  let instrs = state.instrs in
  let wc = state.wc in
  match node with
  | Ast.Literal lit ->
      let new_instr = LDC lit in
      { state with instrs = instrs @ [ new_instr ]; wc = state.wc + 1 }
  | Ast.Block body ->
      let locals = scan_for_locals body in
      let num_locals = List.length locals in
      let extended_ce = compile_time_environment_extend locals state.ce in

      (* First add ENTER_SCOPE *)
      let enter_scope_instr = ENTER_SCOPE { num = num_locals } in
      let state_after_enter =
        {
          instrs = state.instrs @ [ enter_scope_instr ];
          wc = wc + 1;
          ce = extended_ce;
        }
      in

      (* Then compile body *)
      let state_after_body = compile body state_after_enter in

      (* Finally add EXIT_SCOPE *)
      let exit_scope_instr = EXIT_SCOPE in
      {
        state_after_body with
        wc = state_after_body.wc + 1;
        instrs = state_after_body.instrs @ [ exit_scope_instr ];
      }
  | Binop { sym; frst; scnd } ->
      let frst_state = compile frst state in
      let sec_state = compile scnd frst_state in
      let new_instr = BINOP { sym } in
      {
        instrs = sec_state.instrs @ [ new_instr ];
        wc = sec_state.wc + 1;
        ce = sec_state.ce;
      }
  | Unop { sym; frst } ->
      let state_aft_frst = compile frst state in
      let new_instr = UNOP { sym } in
      {
        instrs = state_aft_frst.instrs @ [ new_instr ];
        wc = state_aft_frst.wc + 1;
        ce = state_aft_frst.ce;
      }
  | Sequence stmts -> compile_sequence stmts state
  | Let { sym; expr } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instr = ASSIGN pos in
      {
        state with
        instrs = state_after_expr.instrs @ [ new_instr ];
        wc = wc + 1;
      }
  (* TODO: | Lam { prms; body} -> 
        let state_aft_body = compile body state in 
        let new_instr =  *)
  | Fun { sym; prms; body } ->
      compile (Let { sym; expr = Lam { prms; body } }) state
  | Nam sym ->
      let pos = get_compile_time_environment_pos sym state.ce in
      { state with instrs = instrs @ [ LD { sym; pos } ]; wc = wc + 1 }
  | other ->
      failwith
        (Printf.sprintf "Unexpected json tag %s" (Ast.show_ast_node other))

and compile_sequence stmts state =
  match stmts with
  | [] ->
      {
        state with
        instrs = state.instrs @ [ LDC Undefined ];
        wc = state.wc + 1;
      }
  | [ single ] -> compile single state
  | hd :: tl ->
      let aft_hd_state = compile hd state in
      let aft_hd_with_pop_state =
        {
          aft_hd_state with
          instrs = aft_hd_state.instrs @ [ POP ];
          wc = aft_hd_state.wc + 1;
        }
      in
      compile_sequence tl aft_hd_with_pop_state

let string_of_instruction = show_compiled_instruction

let compile_program json_str =
  let parsed_json = Yojson.Basic.from_string json_str in
  let ast = Ast.of_json parsed_json in
  let state = compile ast initial_state in
  state.instrs @ [ DONE ]
