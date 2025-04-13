type pos_in_env = { frame_index : int; value_index : int } [@@deriving show]

type compiled_instruction =
  | LDC of Value.lit_value
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | JOF of int
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
  | BORROW of bool
  | FREE of { pos : pos_in_env; to_free: bool}
  | DONE
[@@deriving show]

(* Compile time state *)
type state = {
  instrs : compiled_instruction list; (* Symbol table with positions *)
  ce : string list list;
  wc : int;
  borrowed_last_use : (string, int) Hashtbl.t;
}

(* TODO: Add global compile environment with builtin frames *)
let initial_state = { instrs = []; ce = []; wc = 0; borrowed_last_use = Hashtbl.create 100 }

(** Helper functions *)
let rec scan_for_locals (node : Ast.ast_node) =
  let open Ast in
  match node with
  | Let { sym; _ } | Const { sym; _ } | Fun { sym; _ } -> [ sym ]
  | Sequence stmts ->
      List.fold_left (fun acc x -> acc @ scan_for_locals x) [] stmts
  | _ -> []

let rec scan_for_used_symbols (node : Ast.ast_node) =
  let open Ast in
  match node with
  | Nam sym -> [sym]
  | Let { expr; _ } | Const { expr; _ } | Borrow { expr; _ } -> scan_for_used_symbols expr
  | Binop { frst; scnd; _ } -> scan_for_used_symbols frst @ scan_for_used_symbols scnd
  | Unop { frst; _ } -> scan_for_used_symbols frst
  | Sequence stmts -> List.fold_left (fun acc x -> acc @ scan_for_used_symbols x) [] stmts
  | Block body -> scan_for_used_symbols body
  | _ -> []

let find_captured_variables block locals =
  let used_symbols = scan_for_used_symbols block in
  let used_symbols = List.sort_uniq String.compare used_symbols in
  let locals = List.sort_uniq String.compare locals in
  List.filter (fun sym -> not (List.mem sym locals)) used_symbols

let get_compile_time_environment_pos sym ce =
  let reversed_ce = List.rev ce in
  let rec helper sym ce cur_frame_index =
    match ce with
    | [] -> failwith "Symbol not found in compile time environment"
    | cur_frame :: tl_frames -> (
        let maybe_sym_index =
          Utils.find_index (fun x -> String.equal x sym) cur_frame
        in
        match maybe_sym_index with
        | Some sym_index ->
            { frame_index = cur_frame_index; value_index = sym_index }
        | None -> helper sym tl_frames (cur_frame_index + 1))
  in
  helper sym reversed_ce 0

let compile_time_environment_extend frame_vars ce = [ frame_vars ] @ ce

(* Compilation functions *)
let rec compile (node : Ast.ast_node) state =
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
          borrowed_last_use = state.borrowed_last_use;
        }
      in

      (* Then compile body *)
      let state_after_body = compile body state_after_enter in

      (* based on locals, find the reference variables *)
      let borrowed_locals = List.filter (fun sym -> Hashtbl.mem state_after_body.borrowed_last_use sym) locals in



      (* create list of (sym, value) pairs from borrowed locals *)
      let indexes_of_free_instr = List.map (fun sym -> 
        (sym, Hashtbl.find state_after_body.borrowed_last_use sym)
      ) borrowed_locals in

      (* change the free instructions at specific indices to have to_free = true *)
      let new_marked_instrs = List.mapi (fun i instr -> 
        match instr with
        | FREE { pos; _ } when List.exists (fun (_, index) -> index = i) indexes_of_free_instr -> 
          FREE { pos; to_free = true }
        | other -> other
      ) state_after_body.instrs in
      
      (* freeing non borrowed locals  *)
      let non_borrowed_locals = List.filter (fun sym -> not (Hashtbl.mem state_after_body.borrowed_last_use sym)) locals in
      
      (* print all locals and their last uses *)
      print_endline "non borrowed locals:";
      List.iter (fun sym ->
        Printf.printf "%s\n" sym
      ) non_borrowed_locals;

     
      (* add FREE instructions for the non borrowed locals *)
      let owned_free_instrs =  List.map (fun sym -> FREE { pos = get_compile_time_environment_pos sym state_after_body.ce; to_free = true }) non_borrowed_locals in

      (* Finally add EXIT_SCOPE *)
      let exit_scope_instr = EXIT_SCOPE in
      let exit_scope_state = {
        state with
        wc = List.length new_marked_instrs + List.length owned_free_instrs + 1;
        instrs =  new_marked_instrs @ owned_free_instrs @ [ exit_scope_instr ];
      } in

      (* freeing/updating borrowed captured vars *)
      let captured_vars = find_captured_variables body locals in

      (* check if the captured vars are borrowed *)
      let borrowed_captured_vars = List.filter (fun sym -> Hashtbl.mem state_after_body.borrowed_last_use sym) captured_vars in

      (* add FREE instructions for the borrowed captured vars *)
      let new_free_instrs_for_borrowed_captured_vars = List.map (fun sym -> FREE { pos = get_compile_time_environment_pos sym state.ce; to_free = false }) borrowed_captured_vars in

      (* update last_use indices for the borrowed captured vars *)
      let borrowed_last_use_updated = Hashtbl.copy state_after_enter.borrowed_last_use in
      List.iteri (fun i sym -> 
        Hashtbl.replace borrowed_last_use_updated sym (exit_scope_state.wc + i)
      ) borrowed_captured_vars;

      let after_exit_scope_state = {
        exit_scope_state with
        instrs = exit_scope_state.instrs @ new_free_instrs_for_borrowed_captured_vars;
        wc = exit_scope_state.wc + List.length new_free_instrs_for_borrowed_captured_vars;
        borrowed_last_use = borrowed_last_use_updated;
      } in

      after_exit_scope_state

  | Binop { sym; frst; scnd } ->
    (* scan for all used symols in frst and scnd*)
    
      let frst_state = compile frst state in
      let sec_state = compile scnd frst_state in
      let new_instr = BINOP { sym } in
      let after_binop_state = {
        instrs = sec_state.instrs @ [ new_instr ];
        wc = sec_state.wc + 1;
        ce = sec_state.ce;
        borrowed_last_use = sec_state.borrowed_last_use;
      } in
      let used_symbols = scan_for_used_symbols frst @ scan_for_used_symbols scnd in
      (* filter out the borrowed locals *)
      let used_symbols = List.filter (fun sym -> (Hashtbl.mem sec_state.borrowed_last_use sym)) used_symbols in
      (* create a list of free instructions for the used symbols *)
      let free_instrs = List.map (fun sym -> FREE { pos = get_compile_time_environment_pos sym sec_state.ce; to_free = false }) used_symbols in
      (* update the borrowed_last_use *)
      let borrowed_last_use_updated = Hashtbl.copy sec_state.borrowed_last_use in
      List.iteri (fun i sym -> 
        Hashtbl.replace borrowed_last_use_updated sym (after_binop_state.wc + i)
      ) used_symbols;
      {
        after_binop_state with
        instrs = after_binop_state.instrs @ free_instrs;
        wc = after_binop_state.wc + List.length free_instrs;
        borrowed_last_use = borrowed_last_use_updated;
      }
  | Unop { sym; frst } ->
      let state_aft_frst = compile frst state in
      let new_instr = UNOP { sym } in
      let after_unop_state = {
        instrs = state_aft_frst.instrs @ [ new_instr ];
        wc = state_aft_frst.wc + 1;
        ce = state_aft_frst.ce;
        borrowed_last_use = state_aft_frst.borrowed_last_use;
      } in
      let used_symbols = scan_for_used_symbols frst in

  

      (* filter out borrowed locals *)
      let used_symbols = List.filter (fun sym -> (Hashtbl.mem state_aft_frst.borrowed_last_use sym)) used_symbols in
      (* create a list of free instructions for the used symbols *)
      let free_instrs = List.map (fun sym -> FREE { pos = get_compile_time_environment_pos sym state_aft_frst.ce; to_free = false }) used_symbols in

      (* print length of free_instrs *)

      (* update the borrowed_last_use *)
      let borrowed_last_use_updated = Hashtbl.copy state_aft_frst.borrowed_last_use in
      List.iteri (fun i sym -> 
        Hashtbl.replace borrowed_last_use_updated sym (after_unop_state.wc + i)
      ) used_symbols;
      {
        after_unop_state with
        instrs = after_unop_state.instrs @ free_instrs;
        wc = after_unop_state.wc + List.length free_instrs;
        borrowed_last_use = borrowed_last_use_updated;
      }
  | Borrow { is_mutable; expr } ->
      let state_aft_expr = compile expr state in
      let borrow_instr = BORROW is_mutable in
      {
        instrs = state_aft_expr.instrs @ [ borrow_instr ];
        wc = state_aft_expr.wc + 1;
        ce = state_aft_expr.ce;
        borrowed_last_use = state_aft_expr.borrowed_last_use;
      }
  | Sequence stmts -> compile_sequence stmts state
  | Let { sym; expr; _ } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instrs = 
        match expr with
        | Borrow { is_mutable = _; _ } -> 
          (* add sym into borrowed_last_use *)
          Hashtbl.replace state_after_expr.borrowed_last_use sym (state_after_expr.wc + 1);
          [ASSIGN pos; FREE { pos; to_free = false }]
        | _ -> [ASSIGN pos]
      in
      {
        state_after_expr with
        instrs = state_after_expr.instrs @ new_instrs;
        wc = state_after_expr.wc + List.length new_instrs;
      }
  | Const { sym; expr; _ } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instrs = 
        match expr with
        | Borrow { is_mutable = _; _ } -> 
          (* add sym into borrowed_last_use *)
          Hashtbl.replace state_after_expr.borrowed_last_use sym (state_after_expr.wc + 1);
          [ASSIGN pos; FREE { pos; to_free = false }]
        | _ -> [ASSIGN pos]
      in
      {
        state_after_expr with
        instrs = state_after_expr.instrs @ new_instrs;
        wc = state_after_expr.wc + List.length new_instrs;
      }
  | Lam { prms; body } ->
      let loadFunInstr = LDF { arity = List.length prms; addr = wc + 2 } in
      let gotoInstrIndex = wc + 1 in
      (* Index where GOTO will be *)
      let state_after_ldf_goto =
        {
          state with
          instrs = instrs @ [ loadFunInstr; GOTO 0 ];
          (* add LDF, then GOTO 0 placeholder *)
          wc = wc + 2;
        }
      in

      (* extend compile-time environment and compile body *)
      let param_names = prms in
      let extended_ce = compile_time_environment_extend param_names state.ce in
      let after_body_state =
        compile body { state_after_ldf_goto with ce = extended_ce }
      in

      (* add undefined and reset *)
      let final_state =
        {
          state_after_ldf_goto with
          instrs = after_body_state.instrs @ [ LDC Undefined; RESET ];
          wc = after_body_state.wc + 2;
        }
      in

      (* Update GOTO to point to instruction after the function body *)
      let updated_instrs =
        List.mapi
          (fun i instr ->
            if i = gotoInstrIndex then GOTO final_state.wc
              (* Point to after all function instructions *)
            else instr)
          final_state.instrs
      in
      { final_state with instrs = updated_instrs }
  | Fun { sym; prms; body; _ } ->
      compile (Let { sym; expr = Lam { prms; body }; is_mutable = false }) state
  | Nam sym ->
      let pos = get_compile_time_environment_pos sym state.ce in
      { state with instrs = instrs @ [ LD { sym; pos } ]; wc = wc + 1 }
  | Ret expr -> (
      let state_after_expr = compile expr state in
      match expr with
      | App { args; _ } ->
          let new_instrs =
            List.mapi
              (fun i instr ->
                if i = List.length state_after_expr.instrs - 1 then
                  TAILCALL (List.length args)
                else instr)
              state_after_expr.instrs
          in
          { state_after_expr with instrs = new_instrs }
      | _ ->
          {
            state_after_expr with
            instrs = state_after_expr.instrs @ [ RESET ];
            wc = state_after_expr.wc + 1;
          })
  | App { fun_nam; args } ->
      (* Compile the function expression *)
      let state_after_fun = compile fun_nam state in

      (* Compile each argument *)
      let state_after_args =
        List.fold_left (fun state arg -> compile arg state) state_after_fun args
      in

      (* Add CALL instruction with the number of arguments *)
      let new_instr = CALL (List.length args) in
      let after_call_state = { state_after_args with 
        instrs = state_after_args.instrs @ [new_instr]; 
        wc = state_after_args.wc + 1 } in

      (* check in args to filter all nam, if there are any borrowed locals used *)
      let used_symbols = List.fold_left (fun acc arg -> acc @ scan_for_used_symbols arg) [] args in
      let borrowed_locals = List.filter (fun sym -> Hashtbl.mem after_call_state.borrowed_last_use sym) used_symbols in

      (* add free for each of the borrowed locals *)
      let free_instrs = List.map (fun sym -> FREE { pos = get_compile_time_environment_pos sym after_call_state.ce; to_free = false }) borrowed_locals in

      (* update borrowed_last_use *)
      let borrowed_last_use_updated = Hashtbl.copy after_call_state.borrowed_last_use in
      List.iteri (fun i sym -> 
        Hashtbl.replace borrowed_last_use_updated sym (after_call_state.wc + i)
      ) borrowed_locals;

      (* add free instructions to the instrs *)
      { after_call_state with instrs = after_call_state.instrs @ free_instrs; wc = after_call_state.wc + List.length free_instrs; borrowed_last_use = borrowed_last_use_updated }

  | While { pred; body } ->
      (* Compile the predicate *)
      let state_after_pred = compile pred state in
      let state_after_jof = {
        state_after_pred with
        instrs = state_after_pred.instrs @ [ JOF 0 ];
        wc = state_after_pred.wc + 1;
      } in

      (* Compile the body *)
      let state_after_body = compile body state_after_jof in

      (* Add POP and GOTO *)
      let state_after_pop_goto = {
        state_after_body with
        instrs = state_after_body.instrs @ [ POP; GOTO state.wc ];
        wc = state_after_body.wc + 2;
      } in

      (* modify jof to point to the body *)
      { state_after_pop_goto with
        instrs = List.mapi (fun i instr -> 
          if i = state_after_pred.wc
          then JOF state_after_pop_goto.wc
          else instr)
        state_after_pop_goto.instrs @ [ LDC Undefined ];
        wc = state_after_pop_goto.wc + 1;
      }
  | Assign { sym; expr } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in

      if Hashtbl.mem state_after_expr.borrowed_last_use sym then
        let borrowed_last_use_updated = Hashtbl.copy state_after_expr.borrowed_last_use in
        Hashtbl.replace borrowed_last_use_updated sym (state_after_expr.wc + 1);

        { state_after_expr with
          instrs = state_after_expr.instrs @ [ ASSIGN pos; FREE { pos = pos; to_free = false } ];
          wc = state_after_expr.wc + 2;
          borrowed_last_use = borrowed_last_use_updated;
        }
      else
        { state_after_expr with
          instrs = state_after_expr.instrs @ [ ASSIGN pos ];
          wc = state_after_expr.wc + 1;
        }
  | Cond { pred; cons; alt } ->
      (* Compile the predicate *)
      let state_after_pred = compile pred state in

      (* Add placeholder JOF instruction *)
      let state_after_jof =
        {
          state_after_pred with
          instrs = state_after_pred.instrs @ [ JOF 0 ];
          wc = state_after_pred.wc + 1;
        }
      in

      (* Compile the true block *)
      let state_after_cons = compile cons state_after_jof in

      (* Add GOTO to the end of the true block *)
      let state_after_goto =
        {
          state_after_cons with
          instrs = state_after_cons.instrs @ [ GOTO 0 ];
          wc = state_after_cons.wc + 1;
        }
      in

      (* Compile the false block *)
      let state_after_alt =
        compile alt
          {
            state_after_goto with
            instrs =
              List.mapi
                (fun i instr ->
                  if i = state_after_pred.wc then JOF state_after_goto.wc
                  else instr)
                state_after_goto.instrs;
          }
      in

      (* Modify GOTO to point to the end of the false block *)
      {
        state_after_alt with
        instrs =
          List.mapi
            (fun i instr ->
              if i = state_after_cons.wc then GOTO state_after_alt.wc else instr)
            state_after_alt.instrs;
      }

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
  let typed_ast = Ast.of_json parsed_json in
  let ast = Ast.strip_types typed_ast in
  let state = compile ast initial_state in
  state.instrs @ [ DONE ]
