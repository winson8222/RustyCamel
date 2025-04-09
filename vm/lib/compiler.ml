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
  | TAILCALL of int
  | CALL of int
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
  | Let { sym; _ } | Const { sym; _ } | Fun { sym; _ } -> [ sym ]
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
  let open Ast in
  let instrs = state.instrs in
  let wc = state.wc in
  match node with
  | Literal lit ->
      let new_instr = LDC lit in
      { state with instrs = instrs @ [ new_instr ]; wc = state.wc + 1 }
  | Block body ->
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
  | Sequence stmts -> 
      compile_sequence stmts state
  | Let { sym; expr } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instr = ASSIGN pos in
      { state_after_expr with instrs = state_after_expr.instrs @ [ new_instr ]; wc = state_after_expr.wc + 1 }
  | Const { sym; expr } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instr = ASSIGN pos in
      { state_after_expr with instrs = state_after_expr.instrs @ [ new_instr ]; wc = state_after_expr.wc + 1 }
  | Lam { prms; body } -> 
      let loadFunInstr = LDF {arity = List.length prms; addr = wc + 2} in
      let gotoInstrIndex = wc + 1 in (* Index where GOTO will be *)
      let state_after_ldf_goto = {
        state with
        instrs = instrs @ [loadFunInstr; GOTO 0];  (* add LDF, then GOTO 0 placeholder *)
        wc = wc + 2
      } in

      (* extend compile-time environment and compile body *)
      let param_names = prms in
      let extended_ce = compile_time_environment_extend param_names state.ce in
      let after_body_state = compile body {state_after_ldf_goto with ce = extended_ce} in
      
      (* add undefined and reset *)
      let final_state = {state_after_ldf_goto with instrs = after_body_state.instrs @ [LDC Undefined; RESET]; wc = after_body_state.wc + 2} in
      
      (* Update GOTO to point to instruction after the function body *)
      let updated_instrs = 
        List.mapi (fun i instr -> 
          if i = gotoInstrIndex
          then GOTO (final_state.wc)  (* Point to after all function instructions *)
          else instr) 
        final_state.instrs in
      {final_state with instrs = updated_instrs}
  | Fun { sym; prms; body } ->
      compile (Let { sym; expr = Lam { prms; body } }) state
  | Nam sym ->
      let pos = get_compile_time_environment_pos sym state.ce in
      { state with instrs = instrs @ [ LD { sym; pos } ]; wc = wc + 1 }
  | Ret expr ->
      let state_after_expr = compile expr state in
      (match expr with
      | App { args; _ } ->
          let new_instrs = 
            List.mapi (fun i instr -> 
              if i = List.length state_after_expr.instrs - 1 
              then TAILCALL (List.length args)
              else instr) 
            state_after_expr.instrs in
          {state_after_expr with instrs = new_instrs;}
      | _ -> 
          {state_after_expr with instrs = state_after_expr.instrs @ [RESET]; wc = state_after_expr.wc + 1})
  | App { fun_nam; args } ->
      (* Compile the function expression *)
      let state_after_fun = compile fun_nam state in
      
      (* Compile each argument *)
      let state_after_args = List.fold_left (fun state arg ->
        compile arg state
      ) state_after_fun args in
      
      (* Add CALL instruction with the number of arguments *)
      let new_instr = CALL (List.length args) in
      { state_after_args with 
        instrs = state_after_args.instrs @ [new_instr]; 
        wc = state_after_args.wc + 1 }
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
