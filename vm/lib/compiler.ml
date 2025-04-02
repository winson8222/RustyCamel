open Yojson.Basic.Util

type lit_value = 
  | Int of int
  | String of string 
  | Undefined
[@@deriving show]

type pos_in_env = {
  frame_index: int;
  value_index: int;
}
[@@deriving show]


type compiled_instruction =
  | LDC of lit_value          
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | BINOP of { sym: string }
  | ASSIGN of { pos: pos_in_env }
  | POP
  | LD of { sym: string ; pos: pos_in_env }
  | DONE
[@@deriving show]

(* Compile time state *)
type ct_state = {
  instrs: compiled_instruction list;  (* Symbol table with positions *)
  ce: string list list ;
  wc: int;
}

(* TODO: Add global compile environment with builtin frames *)
let initial_ct_state = {
  instrs = [];
  ce = [];
  wc = 0;
}

let find_index f ls = 
  let rec find_index_helper ls f cur_index = 
    match ls with 
    | [] -> None 
    | hd::tl -> 
      match (f hd) with 
      | true -> Some  cur_index
      | false -> find_index_helper tl f (cur_index + 1)
  in find_index_helper ls f 0

(** Helper functions *)
let rec scan_for_locals comp = 
  let tag = comp |> member "tag" |> to_string in 
  match tag with 
  | "let" | "const" | "fun" -> 
    let sym = comp |> member "sym" |> to_string in
    [sym]
  | "seq" ->  (
      let value = comp |> member "stmts" in
      match value with 
      | `List stmts -> List.fold_left (fun acc x -> acc @ scan_for_locals x) [] stmts
      | _ -> failwith "Unexpected case. Sequence stmts should be a list"
    )
  | _ -> []

let get_compile_time_environment_pos sym ce = 
  let rec helper sym ce cur_frame_index cur_val_index = 
    match ce with 
    | [] -> failwith "Symbol not found in compile time environment"
    | cur_frame::tl_frames -> 
      let maybe_sym_index = find_index (fun x -> String.equal x sym) cur_frame in
      match maybe_sym_index with 
      | Some sym_index -> { frame_index = cur_frame_index; value_index = sym_index}
      | None -> helper sym tl_frames (cur_frame_index + 1) (cur_val_index + 1)
  in
  helper sym ce 0 0 

let compile_time_environment_extend frame_vars ce = 
  [frame_vars] @ ce 

(* Compilation functions *)
let rec compile_comp comp ct_state = 
  let tag = comp |> member "tag" |> to_string in
  let instrs = ct_state.instrs in
  let wc = ct_state.wc in
  match tag with 
  | "lit" -> 
    let value = member "val" comp in
    let new_instr = (
      match value with
      | `Int i -> LDC (Int i)
      | `String s -> LDC (String s)
      | _ -> failwith "Invalid literal type"
    ) in
    let new_state= {
      ct_state with
      instrs = instrs @ [new_instr];
      wc = ct_state.wc + 1
    } 
    in new_state
  | "blk" -> 
    (let body = member "body" comp in
     let locals = scan_for_locals body in
     let num_locals =  List.length locals in
     let extended_ce = compile_time_environment_extend locals ct_state.ce in
     let after_body_state =  compile body { ct_state with 
                                            ce = extended_ce;
                                            wc = wc + 1
                                          } in
     let enter_scope_instr = ENTER_SCOPE { num=num_locals } in
     let exit_scope_instr = EXIT_SCOPE in
     let new_state = {
       after_body_state with
       wc = after_body_state.wc + 1;
       instrs = [enter_scope_instr] @ after_body_state.instrs @ [exit_scope_instr]
     } in new_state
    )
  | "binop" -> 
    let frst = member "frst" comp in 
    let scnd = member "scnd" comp in 
    let sym = member "sym" comp |> to_string in 
    let frst_state = compile frst ct_state in
    let sec_state = compile scnd frst_state in 
    let new_instr = BINOP { sym=sym } in
    let new_state = {
      instrs=sec_state.instrs @ [new_instr];
      wc = sec_state.wc + 1;
      ce= sec_state.ce
    } in new_state

  | "seq" -> 
    let stmts = comp |> member "stmts" in
    compile_sequence stmts ct_state 
  | "let" ->  
    (
      let sym = comp |> member "sym" |> to_string in
      let pos = get_compile_time_environment_pos sym ct_state.ce in
      let new_instr = ASSIGN { pos=pos } in
      let new_state = {
        ct_state with
        instrs=instrs @ [new_instr];
        wc=wc+1
      }
      in new_state)
  | "nam" -> 
    let sym = comp |> to_string in
    let pos = get_compile_time_environment_pos sym ct_state.ce in
    { ct_state with
      instrs = instrs @ [LD { sym=sym; pos=pos }];
      wc=wc + 1
    } 
  | other -> failwith (Printf.sprintf "Unexpected json tag %s" other)

and compile comp ce = 
  compile_comp comp ce

and compile_sequence stmts ct_state = 
  match stmts with
  | `List [] -> 
    { ct_state with 
      instrs = ct_state.instrs @ [LDC Undefined]; 
      wc = ct_state.wc + 1 
    }
  | `List [single] -> 
    compile single ct_state
  | `List (hd::tl) ->
    let aft_hd_state = compile hd ct_state in
    let aft_hd_with_pop_state = { 
      aft_hd_state with 
      instrs = aft_hd_state.instrs @ [POP];
      wc = aft_hd_state.wc + 1 
    } in
    compile_sequence (`List tl) aft_hd_with_pop_state
  | _ -> 
    failwith "Expected a JSON list for sequence compilation"

let string_of_instruction = show_compiled_instruction
let compile_program json_str = 
  let parsed_json = Yojson.Basic.from_string json_str in
  let ct_state = compile parsed_json initial_ct_state in
  ct_state.instrs @ [DONE]