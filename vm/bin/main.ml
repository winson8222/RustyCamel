
open Yojson.Basic.Util
 
type lit_value = 
  | Int of int
  | String of string 

(* type load_variable = { sym: symbol; pos: int } *)

type compiled_instruction =
| LDC of lit_value             (* Load Constant *)
| ENTER_SCOPE of { num : int }            (* int num *)
| EXIT_SCOPE
(*| LD of load_variable          (* Load from environment with position *) *)
(*| DONE                         (* Program termination *) *)

(* Environment types *)
type compile_time_state = {
  instrs: compiled_instruction list;  (* Symbol table with positions *)
  ce: string array array ; (* array of array of names *)
  wc: int;
}

let initial_compile_time_state = {
  instrs = [];
  ce = [||];
  wc = 0;
}

(* Compiler functions *)
let rec compile_comp comp compile_time_state = 
  let tag = comp |> member "tag" |> to_string in
    match tag with 
      | "lit" -> 
          let value = member "val" comp in
          let new_instr = (
            match value |> to_string_option with
              | Some s -> LDC (String s) 
              | None -> 
                  match value |> to_int_option with
                  | Some i -> LDC (Int i)  (* If it's an integer *)
                  | None -> failwith "Invalid literal type"
              ) 
              in
              let new_state= {
                compile_time_state with
            instrs = compile_time_state.instrs @ [new_instr];
            wc = compile_time_state.wc + 1
              } in new_state
      | "blk" -> 
        (let body = member "body" comp in
        let enter_scope_instr = ENTER_SCOPE { num=2} in (* TOOD: change num locals*)
        let extended_ce = compile_time_state.ce in
        let after_body_state =  compile body { compile_time_state with 
           ce = extended_ce;
           wc = compile_time_state.wc + 1
          } in
          let exit_scope_instr = EXIT_SCOPE in
          let new_state = {
            after_body_state with
            wc = after_body_state.wc + 1;
            instrs = [enter_scope_instr] @ after_body_state.instrs @ [exit_scope_instr]
          } in new_state
        )
      | _ -> failwith "Unexpected json tag"

and compile comp ce = 
  compile_comp comp ce

let compile_program json_str = 
  let parsed_json = Yojson.Basic.from_string json_str in
  let compile_time_state = compile parsed_json initial_compile_time_state in
  compile_time_state.instrs

  (* For printing instruction *)
  let string_of_instruction = function
  | LDC (Int i) -> Printf.sprintf "LDC(Int %d)" i
  | LDC (String s) -> Printf.sprintf "LDC(String %s)" s
  | ENTER_SCOPE { num: int } -> Printf.sprintf "ENTER_SCOPE with num %s" (string_of_int num)
  | EXIT_SCOPE -> Printf.sprintf "EXIT SCOPE"

  
  let () = 
  let test_json = "{\"tag\": \"blk\", \"body\": {\"tag\": \"lit\", \"val\": \"momo\"}}" in
  let instructions = compile_program test_json in
  List.iter (fun instr -> 
    Printf.printf "%s\n" (string_of_instruction instr)
  ) instructions;
  ()