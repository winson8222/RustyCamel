open Compiler

type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined
  | VAddress of int

type vm_error =
  | TypeError of string

type frame = {
  return_addr: int;
  return_pc: int;
}

type state = {
  pc: int;
  os: vm_value list;
  rts: frame list
}

let initial_state = {
  pc = 0;
  os = [];
  rts = [];
}

let run instrs = 
  let rec run_helper instrs state = 
    let instr = List.nth instrs state.pc in
    match instr with 
    | DONE -> Ok (List.nth state.os (List.length state.os - 1))
    | _ -> run_helper instrs { state with pc = state.pc + 1}
  in 
  run_helper instrs initial_state