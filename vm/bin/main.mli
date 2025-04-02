
type lit_value = 
  | Int of int
  | String of string 
  | Undefined

(* type load_variable = { sym: symbol; pos: int } *)

type compiled_instruction =
  | LDC of lit_value             (* Load Constant *)
  | ENTER_SCOPE of { num : int }            (* int num *)
  | EXIT_SCOPE
  | BINOP of { sym: string }
  | ASSIGN of { pos: int }
  | POP

  
  val string_of_instruction : compiled_instruction -> string
  
  type ct_state = {
    instrs: compiled_instruction list;  (* Symbol table with positions *)
    ce: string array array ; (* array of array of names *)
    wc: int;
    }
    
val compile_sequence : Yojson.Basic.t -> ct_state -> ct_state
val compile_comp : Yojson.Basic.t -> ct_state -> ct_state
val compile_program : string -> compiled_instruction list
val compile : Yojson.Basic.t -> ct_state -> ct_state