open Ast

type pos_in_env = { frame_index : int; value_index : int }

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

val string_of_instruction : compiled_instruction -> string

type state = {
  instrs : compiled_instruction list; (* Symbol table with positions *)
  ce : string list list; (* list of frames—list of syms *)
  wc : int;
  used_symbols : (string, pos_in_env) Hashtbl.t;
  is_top_level : bool;
}

val get_compile_time_environment_pos : string -> string list list -> pos_in_env
val compile_sequence : Ast.ast_node list -> state -> state
val compile_program : string -> compiled_instruction list
val compile : Ast.ast_node -> state -> state

val compile_time_environment_extend :
  string list -> string list list -> string list list
