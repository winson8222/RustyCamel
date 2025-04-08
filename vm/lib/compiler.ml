type pos_in_env = { frame_index : int; value_index : int } [@@deriving show]

type compiled_instruction =
  | LDC of Value.lit_value
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | BINOP of { sym : string }
  | ASSIGN of  pos_in_env 
  | POP
  | LD of { sym : string; pos : pos_in_env }
  | RESET
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
  | Let { sym }
  | Const { sym }
  | Function { sym; params = _; body = _ } ->
      [ sym ]
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
      let after_body_state =
        compile body { state with ce = extended_ce; wc = wc + 1 }
      in
      let enter_scope_instr = ENTER_SCOPE { num = num_locals } in
      let exit_scope_instr = EXIT_SCOPE in
      let new_state =
        {
          after_body_state with
          wc = after_body_state.wc + 1;
          instrs =
            (enter_scope_instr :: after_body_state.instrs)
            @ [ exit_scope_instr ];
        }
      in
      new_state
  | BinOp { sym; frst; scnd} ->
      let frst_state = compile frst state in
      let sec_state = compile scnd frst_state in
      let new_instr = BINOP { sym } in
        {
          instrs = sec_state.instrs @ [ new_instr ];
          wc = sec_state.wc + 1;
          ce = sec_state.ce;
        }
  | Sequence stmts ->
      compile_sequence stmts state
  | Let { sym } ->
      let pos = get_compile_time_environment_pos sym state.ce in
      let new_instr = ASSIGN pos in
        { state with instrs = instrs @ [ new_instr ]; wc = wc + 1 }
  | Nam sym ->
      let pos = get_compile_time_environment_pos sym state.ce in
      { state with instrs = instrs @ [ LD { sym; pos } ]; wc = wc + 1 }
  (* | Ret expr -> *)
      (* compile instruction which potentially loads into OS *)
      (* let expr_state = compile expr state in
      { state with instrs = expr_state.instrs @ [ RESET ] } *)
      (* | "fun" -> 
        (
          let sym = comp |> member "sym" |> to_string in 
          let prms = comp |> member "prms" in
          let body = comp |> member "body" in 
          let sym_pos = get_compile_time_environment_pos sym state.ce in
          let new_instr = ASSIGN { pos=sym_pos } in
          let new_state = { state with instrs = instrs @ [new_instr]; wc = wc + 1} *)

      (* ) *)
  | other -> failwith (Printf.sprintf "Unexpected json tag %s" (Ast.show_ast_node other ))

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
