open Yojson.Basic.Util

type lit_value = Int of int | String of string | Boolean of bool | Undefined
[@@deriving show]

type pos_in_env = { frame_index : int; value_index : int } [@@deriving show]

type compiled_instruction =
  | LDC of lit_value
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
let rec scan_for_locals comp =
  let tag = comp |> member "tag" |> to_string in
  match tag with
  | "let" | "const" | "fun" ->
      let sym = comp |> member "sym" |> to_string in
      [ sym ]
  | "seq" -> (
      let value = comp |> member "stmts" in
      match value with
      | `List stmts ->
          List.fold_left (fun acc x -> acc @ scan_for_locals x) [] stmts
      | _ -> failwith "Unexpected case. Sequence stmts should be a list")
  | _ -> []

let get_compile_time_environment_pos sym ce =
  let rec helper sym ce cur_frame_index cur_val_index =
    match ce with
    | [] -> failwith "Symbol not found in compile time environment"
    | cur_frame :: tl_frames -> (
        let maybe_sym_index =
          find_index (fun x -> String.equal x sym) cur_frame
        in
        match maybe_sym_index with
        | Some sym_index ->
            { frame_index = cur_frame_index; value_index = sym_index }
        | None -> helper sym tl_frames (cur_frame_index + 1) (cur_val_index + 1)
        )
  in
  helper sym ce 0 0

let compile_time_environment_extend frame_vars ce = [ frame_vars ] @ ce

(* Compilation functions *)
let rec compile_comp comp state =
  let tag = comp |> member "tag" |> to_string in
  let instrs = state.instrs in
  let wc = state.wc in
  match tag with
  | "lit" ->
      let value = member "val" comp in
      let new_instr =
        match value with
        | `Int i -> LDC (Int i)
        | `String s -> LDC (String s)
        | `Bool b -> LDC (Boolean b)
        | _ -> failwith "Invalid literal type"
      in
      let new_state =
        { state with instrs = instrs @ [ new_instr ]; wc = state.wc + 1 }
      in
      new_state
  | "blk" ->
      let body = member "body" comp in
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
            [ enter_scope_instr ] @ after_body_state.instrs
            @ [ exit_scope_instr ];
        }
      in
      new_state
  | "binop" ->
      let frst = member "frst" comp in
      let scnd = member "scnd" comp in
      let sym = member "sym" comp |> to_string in
      let _ = Printf.printf "binop before first: wc=%d\n" state.wc in
      let frst_state = compile frst state in
      let _ = Printf.printf "binop after first: wc=%d\n" frst_state.wc in
      let sec_state = compile scnd frst_state in
      let _ = Printf.printf "binop after second: wc=%d\n" sec_state.wc in
      let new_instr = BINOP { sym } in
      let new_state =
        {
          instrs = sec_state.instrs @ [ new_instr ];
          wc = sec_state.wc + 1;
          ce = sec_state.ce;
        }
      in
      let _ = Printf.printf "binop final: wc=%d\n" new_state.wc in
      new_state
  | "unop" ->
      let frst = member "frst" comp in
      let sym = member "sym" comp |> to_string in
      let frst_state = compile frst state in
      let new_instr = UNOP { sym } in
      let new_state =
        {
          instrs = frst_state.instrs @ [ new_instr ];
          wc = frst_state.wc + 1;
          ce = frst_state.ce;
        }
      in
      new_state
  | "seq" ->
      let stmts = comp |> member "stmts" in
      compile_sequence stmts state
  | "let" ->
      let sym = comp |> member "sym" |> to_string in
      let state_after_expr = compile (member "expr" comp) state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instr = ASSIGN pos in
      let new_state =
        { state_after_expr with instrs = state_after_expr.instrs @ [ new_instr ]; wc = state_after_expr.wc + 1 }
      in
      new_state
  | "const" ->
      let sym = comp |> member "sym" |> to_string in
      let state_after_expr = compile (member "expr" comp) state in
      let pos = get_compile_time_environment_pos sym state_after_expr.ce in
      let new_instr = ASSIGN pos in
      let new_state =
        { state_after_expr with instrs = state_after_expr.instrs @ [ new_instr ]; wc = state_after_expr.wc + 1 }
      in
      new_state
  | "nam" ->
      let sym = comp |> member "sym" |> to_string in
      let pos = get_compile_time_environment_pos sym state.ce in
      let new_state =
          { state with instrs = state.instrs @ [ LD { sym; pos } ]; wc = state.wc + 1 }
      in
      new_state
  | "lam" ->
      let prms = member "prms" comp in
      let arity = match prms with `List l -> List.length l | _ -> 0 in
      let loadFuncInstr = LDF {arity = arity; addr = wc + 2} in
      let gotoInstrIndex = wc in (* Index where GOTO will be *)
      let state_after_ldf_goto = {
        state with
        instrs = state.instrs @ [loadFuncInstr; GOTO 0];  (* add LDF, then GOTO 0 placeholder *)
        wc = wc + 2
      } in

      (* extend compile-time environment and compile body *)
      let extended_ce = compile_time_environment_extend (List.map (fun p -> member "name" p |> to_string) (to_list prms)) state.ce in
      let _ = Printf.printf "before body wc: %d\n" state_after_ldf_goto.wc in
      let after_body_state = compile (member "body" comp) {state_after_ldf_goto with ce = extended_ce} in
      let _ = Printf.printf "after_body_state wc: %d\n" after_body_state.wc in
      
      (* add undefined and reset *)
      let final_state = {after_body_state with instrs = after_body_state.instrs @ [LDC Undefined; RESET]; wc = after_body_state.wc + 2} in
      
      (* Update GOTO to point to instruction after the function body *)
      let updated_instrs = 
        List.mapi (fun i instr -> 
          if i = gotoInstrIndex
          then GOTO (final_state.wc)  (* Point to after all function instructions *)
          else instr) 
        final_state.instrs in
      let new_state = {final_state with instrs = updated_instrs; wc = final_state.wc}
      in
      new_state
  | "fun" ->
      let params = member "prms" comp in
      let name = member "sym" comp |> to_string in
      let body = member "body" comp in
      let assigned_lambda_expr =
        `Assoc
          [
            ("tag", `String "let");
            ("sym", `String name);
            ("expr",
              `Assoc
                [ ("tag", `String "lam"); ("prms", params); ("body", body) ] );
          ]
      in
      compile assigned_lambda_expr state
  | "ret" ->
      let expr = member "expr" comp in
      let state_after_expr = compile expr state in
      (match member "tag" expr |> to_string with
      | "app" ->
          let new_instrs = 
            List.mapi (fun i instr -> 
              if i = List.length state_after_expr.instrs - 1 
              then TAILCALL 
              else instr) 
            state_after_expr.instrs in
          let new_state = {state_after_expr with instrs = new_instrs; wc = state_after_expr.wc + 1} in
          new_state
      | _ -> 
          let reset_instr = RESET in
          let new_state = {state_after_expr with instrs = state_after_expr.instrs @ [reset_instr]; wc = state_after_expr.wc + 1} in
          new_state)
  | other -> failwith (Printf.sprintf "Unexpected json tag %s" other)

and compile comp ce = compile_comp comp ce

(* "prms": [
    {
      "type": "Param",
      "name": "n",
      "paramType": {
        "type": "BasicType",
        "name": "i32"
      },
      "ownership": {
        "ownership": "owned",
        "mutability": "immutable"
      }
    }
  ], *)
and compile_sequence stmts state =
  match stmts with
  | `List [] ->
      {
        state with
        instrs = state.instrs @ [ LDC Undefined ];
        wc = state.wc + 1;
      }
  | `List [ single ] -> compile single state
  | `List (hd :: tl) ->
      let aft_hd_state = compile hd state in
      let aft_hd_with_pop_state =
        {
          aft_hd_state with
          instrs = aft_hd_state.instrs @ [ POP ];
          wc = aft_hd_state.wc + 1;
        }
      in
      compile_sequence (`List tl) aft_hd_with_pop_state
  | _ -> failwith "Expected a JSON list for sequence compilation"

(* and compile_func_arg args state = 
  match args with 
  | `List [] -> state
  | `List (hd::tl) -> 
    let aft_hd_state = compile hd state in
    compile_func_arg (`List tl) aft_hd_state
  | _ -> failwith "Expected a JSON list for function argument compilation" *)

let string_of_instruction = show_compiled_instruction

let compile_program json_str =
  let parsed_json = Yojson.Basic.from_string json_str in
  let state = compile parsed_json initial_state in
  state.instrs @ [ DONE ]
