
open Yojson.Basic.Util
 
type lit_value = 
  | Int of int
  | String of string 

(* type load_variable = { sym: symbol; pos: int } *)

type compiled_instruction =
| LDC of lit_value             (* Load Constant *)
| ENTER_SCOPE of { num : int }            (* int num *)
| EXIT_SCOPE
| BINOP of { sym: string }

(*| LD of load_variable          (* Load from environment with position *) *)
(*| DONE                         (* Program termination *) *)

(* Compile time state *)
type ct_state = {
  instrs: compiled_instruction list;  (* Symbol table with positions *)
  ce: string array array ; (* array of array of names *)
  wc: int;
}

let initial_ct_state = {
  instrs = [];
  ce = [||];
  wc = 0;
}

(* Compiler functions *)
let rec compile_comp comp ct_state = 
  let tag = comp |> member "tag" |> to_string in
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
            instrs = ct_state.instrs @ [new_instr];
            wc = ct_state.wc + 1
          } 
        in new_state
      | "blk" -> 
        (let body = member "body" comp in
        let enter_scope_instr = ENTER_SCOPE { num=2 } in (* TOOD: change num locals*)
        let extended_ce = ct_state.ce in
        let after_body_state =  compile body { ct_state with 
           ce = extended_ce;
           wc = ct_state.wc + 1
          } in
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
      | _ -> failwith "Unexpected json tag"

and compile comp ce = 
  compile_comp comp ce

let compile_program json_str = 
  let parsed_json = Yojson.Basic.from_string json_str in
  let ct_state = compile parsed_json initial_ct_state in
  ct_state.instrs

  (* For printing instruction *)
  let string_of_instruction = function
  | LDC (Int i) -> Printf.sprintf "LDC(Int %d)" i
  | LDC (String s) -> Printf.sprintf "LDC(String %s)" s
  | ENTER_SCOPE { num: int } -> Printf.sprintf "ENTER_SCOPE with num %s" (string_of_int num)
  | EXIT_SCOPE -> Printf.sprintf "EXIT SCOPE"
  | BINOP { sym : string } ->  Printf.sprintf "BINOP %s" sym

  
  let () = 
  let test_json = "{\"tag\": \"blk\", \"body\": {\"tag\": \"binop\", \"sym\": \"+\", \"frst\": {\"tag\": \"lit\", \"val\": 2}, \"scnd\": {\"tag\": \"lit\", \"val\": 3}}}" in
  let instructions = compile_program test_json in
  List.iter (fun instr -> 
    Printf.printf "%s\n" (string_of_instruction instr)
  ) instructions;
  ()