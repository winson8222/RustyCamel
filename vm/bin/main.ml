[@@@ocaml.warning "-32"]
open Yojson.Basic.Util

type lit_value = 
  | Int of int
  | String of string

type ast_body =
  | LIT of lit_value
  (* | NAM of string *)
  (* | APP of ast_node * ast_node array
  | LOG of string * ast_node * ast_node
  | BINOP of string * ast_node * ast_node
  | UNOP of string * ast_node
  | LAM of string array * ast_node
  | SEQ of ast_node array
  | BLK of ast_node
  | LET of string * ast_node
  | CONST of string * ast_node
  | ASSMT of string * ast_node
  | COND of ast_node * ast_node * ast_node
  | FUN of string * string array * ast_node
  | RET of ast_node
  | WHILE of ast_node * ast_node *)

(* Note that this is slightly different from source's ast written in TS. 
  All our AST nodes have the field called body *)
and ast_node = {
  ast_tag: string;
  body: ast_body;
}

(* type symbol = string *)

(* type load_variable = { sym: symbol; pos: int } *)

type instruction =
| LDC of lit_value             (* Load Constant *)
(*| LD of load_variable          (* Load from environment with position *) *)
(*| DONE                         (* Program termination *) *)

(* Environment types *)
type compile_time_state = {
  instrs: instruction list;  (* Symbol table with positions *)
  wc: int;
}

let initial_compile_time_state = {
  instrs = [];
  wc = 0;
}

(* Compiler functions *)
let compile_comp comp compile_time_state = 
  let ast_tag = comp.ast_tag in
  match ast_tag with 
  | "lit" -> 
      let instr = match comp.body with
        | LIT lit_value -> LDC lit_value 
      in
      let new_compile_time_state = {
        instrs= compile_time_state.instrs @ [instr];
        wc = compile_time_state.wc + 1
      } in 
      new_compile_time_state
  | _ -> compile_time_state

let compile comp ce = 
  compile_comp comp ce

let parse_literal json =
  let value = member "val" json in
  match value |> to_string_option with
  | Some s -> LIT (String s)  (* If it's a string *)
  | None -> 
      match value |> to_int_option with
      | Some i -> LIT (Int i)  (* If it's an integer *)
      | None -> failwith "Invalid literal type"

let parse_ast json =
  let tag = json |> member "tag" |> to_string in
  {
    ast_tag = tag;
    body = match tag with
    | "lit" -> parse_literal json
    (* | "nam" -> NAM (json |> member "sym" |> to_string) *)
    (* | "app" -> 
        let fun_node = json |> member "fun" |> parse_ast in
        let args = json |> member "args" |> to_list |> List.map parse_ast |> Array.of_list in
        APP (fun_node, args)
    | "log" ->
        let sym = json |> member "sym" |> to_string in
        let frst = json |> member "frst" |> parse_ast in
        let scnd = json |> member "scnd" |> parse_ast in
        LOG (sym, frst, scnd) *)
    | _ -> failwith ("Unknown tag: " ^ tag)
  }

let compile_program json_str = 
  let parsed_json = Yojson.Basic.from_string json_str in
  let ast = parse_ast parsed_json in
  let compile_time_state = compile ast initial_compile_time_state in
  compile_time_state.instrs

  let string_of_instruction = function
  | LDC (Int i) -> Printf.sprintf "LDC(Int %d)" i
  | LDC (String s) -> Printf.sprintf "LDC(String %s)" s
  (* | LD {sym; pos} -> Printf.sprintf "LD(%s, %d)" sym pos *)
  (* | DONE -> "DONE" *)
  (* | _ -> "random string" *)
  
  let () = 
  let instructions = compile_program "{\"tag\": \"lit\", \"val\": \"bla\"}" in
  List.iter (fun instr -> 
    Printf.printf "%s\n" (string_of_instruction instr)
  ) instructions;
  ()