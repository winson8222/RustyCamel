open Compiler

type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined
  | VAddress of int (* byte address *)
[@@deriving show]

type vm_error =
  | TypeError of string
[@@deriving show]
(* type frame = {
   return_addr: int;
   return_pc: int;
   } *)

type t = {
  _heap: Heap.t;
  pc: int;
  os: vm_value list;
  _env_addr: int;
  (* rts: frame list *)
}

let initial_state = {
  _heap=Heap.create;
  pc = 0;
  os = [];
  _env_addr=0;
  (* rts = []; *)
}

let string_of_vm_value = show_vm_value
let string_of_vm_error = show_vm_error

let create = initial_state

let run instrs = 
  let rec run_helper instrs state = 
    Printf.printf "pc:%s" (Int.to_string state.pc);
    let instr = List.nth instrs state.pc in
    match instr with 
    | DONE -> 
      (match state.os with
       | [] -> Ok VUndefined
       | ops -> Ok (List.hd (List.rev ops)))
    | _ -> run_helper instrs { state with pc = state.pc + 1}
  in 
  run_helper instrs initial_state