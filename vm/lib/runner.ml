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

type t = {
  heap: Heap.t;
  pc: int ref;
  os: (vm_value list) ref;
  env_addr: int ref;
  rts: (int list) ref;
}

let initial_state = {
  heap=Heap.create;
  pc = ref 0;
  os = ref [];
  env_addr=ref 0;
  rts = ref [];
}

let string_of_vm_value = show_vm_value
let string_of_vm_error = show_vm_error

let create = initial_state


(** Execute a single VM instruction *)
(* PC is modified by the caller, this function only modifies the rest: heap, os, env_addr *)
let execute_instruction state instr =
  let heap = state.heap in
  let env_addr = !(state.env_addr) in
  match instr with
  | DONE -> (
      match !(state.os) with
      | [] -> Ok VUndefined
      | ops -> Ok (List.hd (List.rev ops))
    )

  | ENTER_SCOPE { num } ->
    ( 
      let new_blockframe_addr = Heap.heap_allocate_blockframe heap ~env_addr:env_addr in
      state.rts := List.append !(state.rts) [new_blockframe_addr];

      let new_frame_addr = Heap.heap_allocate heap ~size:num ~tag:Heap.Frame_tag in
      Heap.heap_set_frame_children_to_unassigned heap ~frame_addr:new_frame_addr ~num_children:num;

      state.env_addr := Heap.heap_env_extend heap ~new_frame_addr:new_frame_addr;
      Ok VUndefined (* The value is not actually used. Only to signal that there's no error *)
    )
  | other -> Error (TypeError (Printf.sprintf "Unrecognized instruction %s" (Compiler.string_of_instruction other)))

(** Main VM execution loop *)
let run instrs = 
  let rec run_helper state = 
    let pc = !(state.pc) in
    Printf.printf "pc:%d\n" pc;

    match List.nth_opt instrs pc with
    | None -> Error (TypeError "Invalid program counter")
    | Some instr ->
      match execute_instruction state instr with
      | Ok _ -> 
        state.pc := pc + 1;
        run_helper state
      | Error e -> Error e (* Early exit in case of error *)
  in 
  run_helper initial_state