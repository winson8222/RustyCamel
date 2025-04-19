open Ast

type pos_in_env = { frame_index : int; value_index : int } [@@deriving show]

type compiled_instruction =
  | LDC of Types.lit_value
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | JOF of int
  | BINOP of binop_sym
  | UNOP of unop_sym
  | BORROW
  | DEREF
  | ASSIGN of pos_in_env
  | POP
  | LD of { pos : pos_in_env }
  | LDF of { arity : int; addr : int }
  | GOTO of int
  | RESET
  | TAILCALL of int
  | CALL of int
  | FREE of { pos : pos_in_env; to_free : bool }
  | DONE
[@@deriving show]

(* Compile time state *)
type state = {
  instrs : compiled_instruction list; (* Symbol table with positions *)
  ce : string list list; 
  wc : int;
  used_symbols: (string, pos_in_env) Hashtbl.t;
  is_top_level: bool; (* New field to track if we're at top level *)
}

(* TODO: Add global compile environment with builtin frames *)
let initial_state = { instrs = []; ce = []; used_symbols = Hashtbl.create 10; wc = 0; is_top_level = true }

(** Helper functions *)
let rec scan_for_locals (node : Ast.ast_node) =
  let open Ast in
  match node with
  | Let { sym; _ } | Const { sym; _ } | Fun { sym; _ } -> [ sym ]
  | Sequence stmts ->
      List.fold_left (fun acc x -> acc @ scan_for_locals x) [] stmts
  | _ -> [] (* this is ok *)

let get_compile_time_environment_pos sym ce =
  let reversed_ce = List.rev ce in
  let n = List.length reversed_ce in
  let rec helper sym ce cur_frame_index =
    match ce with
    | [] -> failwith "Symbol not found in compile time environment"
    | cur_frame :: tl_frames -> (
        let maybe_sym_index =
          Utils.find_index (fun x -> String.equal x sym) cur_frame
        in
        match maybe_sym_index with
        | Some sym_index ->
            Printf.printf "found in frame %d\n" cur_frame_index;
            { frame_index = n - 1 - cur_frame_index; value_index = sym_index }
        | None -> helper sym tl_frames (cur_frame_index + 1))
  in
  helper sym reversed_ce 0

let compile_time_environment_extend frame_vars ce = ce @ [ frame_vars ]

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
      (* make a copy of the used_symbols table *)
      let old_used_symbols = Hashtbl.copy state.used_symbols in

      (* First add ENTER_SCOPE *)
      let enter_scope_instr = ENTER_SCOPE { num = num_locals } in
      let state_after_enter =
        {
          instrs = state.instrs @ [ enter_scope_instr ];
          wc = wc + 1;
          ce = extended_ce;
          used_symbols = state.used_symbols;
          is_top_level = false; (* Set to false when entering a block *)
        }
      in

      (* Then compile body *)
      let state_after_body = compile body state_after_enter in

      let free_instrs =
        if state.is_top_level then [] (* Skip FREE instructions at top level *)
        else
          List.rev_map
            (fun sym ->
              let pos = get_compile_time_environment_pos sym extended_ce in
              FREE { pos; to_free = true })
            locals
      in
  
      (* Add FREE instructions followed by EXIT_SCOPE *)
      let final_instrs = state_after_body.instrs @ free_instrs @ [ EXIT_SCOPE ] in
      {
        state with
        instrs = final_instrs;
        wc = state_after_body.wc + List.length free_instrs + 1;
        is_top_level = state.is_top_level; (* Preserve the top level state *)
        used_symbols = old_used_symbols;
      }
  | Binop { sym; frst; scnd } ->
      let frst_state = compile frst state in
      let sec_state = compile scnd frst_state in
      let new_instr = BINOP sym in
      {
        instrs = sec_state.instrs @ [ new_instr ];
        wc = sec_state.wc + 1;
        ce = sec_state.ce;
        used_symbols = sec_state.used_symbols;
        is_top_level = state.is_top_level;
      }
  | Unop { sym; frst } ->
      let state_aft_frst = compile frst state in
      let new_instr = UNOP sym in
      {
        instrs = state_aft_frst.instrs @ [ new_instr ];
        wc = state_aft_frst.wc + 1;
        ce = state_aft_frst.ce;
        used_symbols = state_aft_frst.used_symbols;
        is_top_level = state.is_top_level;
      }
  | Borrow { expr } ->
      let state_aft_expr = compile expr state in
      let borrow_instr = BORROW in
      {
        instrs = state_aft_expr.instrs @ [ borrow_instr ];
        wc = state_aft_expr.wc + 1;
        ce = state_aft_expr.ce;
        used_symbols = state_aft_expr.used_symbols;
        is_top_level = state.is_top_level;
      }
  | Deref expr ->
      let s = compile expr state in
      { 
        instrs = s.instrs @ [ DEREF ]; 
        wc = s.wc + 1; 
        ce = s.ce; 
        used_symbols = s.used_symbols;
        is_top_level = state.is_top_level;
      }
  | Sequence stmts -> compile_sequence stmts state
  | Let { sym; expr } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      (* TODO: Add symbol to the used_symbols table *)
      let outmost_table = state.used_symbols in
      Hashtbl.add outmost_table sym pos;

      let new_instr = ASSIGN pos in
      {
        state_after_expr with
        instrs = state_after_expr.instrs @ [ new_instr ];
        wc = state_after_expr.wc + 1;
        is_top_level = state.is_top_level;
      }
  | Const { sym; expr; _ } ->
      let state_after_expr = compile expr state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      (* TODO: Add symbol to the used_symbols table *)
      let outmost_table = state.used_symbols in
      Hashtbl.add outmost_table sym pos;

      let new_instr = ASSIGN pos in
      {
        state_after_expr with
        instrs = state_after_expr.instrs @ [ new_instr ];
        wc = state_after_expr.wc + 1;
        is_top_level = state.is_top_level;
      }
  | Fun { sym; prms; body; _ } ->
      let loadFunInstr = LDF { arity = List.length prms; addr = wc + 2 } in
      let gotoInstrIndex = wc + 1 in
      (* Index where GOTO will be *)
      let oldTable = state.used_symbols in
      let newTable = Hashtbl.create 10 in
      let state_after_ldf_goto =
        {
          state with
          instrs = instrs @ [ loadFunInstr; GOTO 0 ];
          (* add LDF, then GOTO 0 placeholder *)
          wc = wc + 2;
          used_symbols = newTable;
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
          used_symbols = oldTable;
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
      let state_aft_fun_expr = { final_state with instrs = updated_instrs } in
      let pos = get_compile_time_environment_pos sym state_aft_fun_expr.ce in
      (* TODO: Add symbol to the used_symbols table *)
      let outmost_table = state.used_symbols in
      Hashtbl.add outmost_table sym pos;

      let new_instr = ASSIGN pos in
      {
        state_aft_fun_expr with
        instrs = state_aft_fun_expr.instrs @ [ new_instr ];
        wc = state_aft_fun_expr.wc + 1;
        is_top_level = state.is_top_level;
      }
  | Nam sym ->
      let pos = get_compile_time_environment_pos sym state.ce in
      { 
        state with 
        instrs = instrs @ [ LD { pos } ]; 
        wc = wc + 1;
        is_top_level = state.is_top_level;
      }
  | Ret expr -> (
        let state_after_expr = compile expr state in
    
        (* Determine if expr is a variable *)
        let excluded_sym =
          match expr with
          | Nam sym -> Some sym
          | Deref (Nam sym) -> Some sym  (* include the symbol of the deref *)
          | _ -> None
        in
    
        (* Generate FREE instructions for everything in used_symbols except excluded_sym *)
        let free_instrs =
          Hashtbl.fold
            (fun sym pos acc ->
              if Some sym = excluded_sym then acc
              else FREE { pos; to_free = true } :: acc)
            state_after_expr.used_symbols
            []
        in
    
        match expr with
        | App { args; _ } ->
            let final_instrs =
              (* replace last instruction with TAILCALL *)
              List.mapi
                (fun i instr ->
                  if i = List.length state_after_expr.instrs - 1 then
                    TAILCALL (List.length args)
                  else instr)
                state_after_expr.instrs
            in
            {
              state_after_expr with
              instrs = final_instrs @ List.rev free_instrs;
            }
        | _ ->
            {
              state_after_expr with
              instrs =
                state_after_expr.instrs @ List.rev free_instrs @ [ RESET ];
              wc = state_after_expr.wc + List.length free_instrs + 1;
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
      {
        state_after_args with
        instrs = state_after_args.instrs @ [ new_instr ];
        wc = state_after_args.wc + 1;
        is_top_level = state.is_top_level;
      }
  | While { pred; body } ->
      (* Compile the predicate *)
      let state_after_pred = compile pred state in
      let state_after_jof =
        {
          state_after_pred with
          instrs = state_after_pred.instrs @ [ JOF 0 ];
          wc = state_after_pred.wc + 1;
          is_top_level = state.is_top_level;
        }
      in

      (* Compile the body *)
      let state_after_body = compile body state_after_jof in

      (* Add POP and GOTO *)
      let state_after_pop_goto =
        {
          state_after_body with
          instrs = state_after_body.instrs @ [ POP; GOTO state.wc ];
          wc = state_after_body.wc + 2;
          is_top_level = state.is_top_level;
        }
      in

      (* modify jof to point to the body *)
      {
        state_after_pop_goto with
        instrs =
          List.mapi
            (fun i instr ->
              if i = state_after_pred.wc then JOF state_after_pop_goto.wc
              else instr)
            state_after_pop_goto.instrs
          @ [ LDC Undefined ];
        wc = state_after_pop_goto.wc + 1;
        is_top_level = state.is_top_level;
      }
  | Assign { sym; expr } ->
      let state_after_expr = compile expr state in
      {
        state_after_expr with
        instrs =
          state_after_expr.instrs
          @ [
              ASSIGN (get_compile_time_environment_pos sym state_after_expr.ce);
            ];
        wc = state_after_expr.wc + 1;
        is_top_level = state.is_top_level;
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
          is_top_level = state.is_top_level;
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
          is_top_level = state.is_top_level;
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
            is_top_level = state.is_top_level;
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
        is_top_level = state.is_top_level;
      }

and compile_sequence stmts state =
  match stmts with
  | [] ->
      {
        state with
        instrs = state.instrs @ [ LDC Undefined ];
        wc = state.wc + 1;
        is_top_level = state.is_top_level;
      }
  | [ single ] -> compile single state
  | hd :: tl ->
      let aft_hd_state = compile hd state in
      let aft_hd_with_pop_state =
        {
          aft_hd_state with
          instrs = aft_hd_state.instrs @ [ POP ];
          wc = aft_hd_state.wc + 1;
          is_top_level = state.is_top_level;
        }
      in
      compile_sequence tl aft_hd_with_pop_state

let string_of_instruction = show_compiled_instruction

let compile_program json_str =
  let parsed_json = Yojson.Basic.from_string json_str in
  let typed_ast = Ast.of_json parsed_json in
  
  (* Type checking *)
  let tc = Type_checker.create () in
  let _ = match Type_checker.check_type typed_ast tc  with 
  | Ok () -> ()
  | Error msg -> failwith ("Error in type checking: " ^ msg ^ "\n")
  in
  (* Ownership checking *)
  let oc = Ownership_checker.create () in 
  let _ = match Ownership_checker.check_ownership typed_ast oc  with 
  | Ok () -> ()
  | Error msg -> failwith ("Error in ownership checking: " ^ msg ^ "\n") 
  in
  
  let ast = Ast.strip_types typed_ast in
  let state = compile ast initial_state in
  state.instrs @ [ DONE ]
