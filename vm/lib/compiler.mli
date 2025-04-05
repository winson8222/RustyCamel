type lit_value = Int of int | String of string | Boolean of bool | Undefined
type pos_in_env = { frame_index : int; value_index : int }

type compiled_instruction =
  | LDC of lit_value
  | ENTER_SCOPE of { num : int }
  | EXIT_SCOPE
  | BINOP of { sym : string }
  | ASSIGN of  pos_in_env 
  | POP
  | LD of { sym : string; pos : pos_in_env }
  | RESET
  | DONE

val string_of_instruction : compiled_instruction -> string

type state = {
  instrs : compiled_instruction list; (* Symbol table with positions *)
  ce : string list list; (* list of frames—list of syms *)
  wc : int;
}

val get_compile_time_environment_pos : string -> string list list -> pos_in_env
val compile_sequence : Yojson.Basic.t -> state -> state
val compile_program : string -> compiled_instruction list
val compile : Yojson.Basic.t -> state -> state

val compile_time_environment_extend :
  string list -> string list list -> string list list
