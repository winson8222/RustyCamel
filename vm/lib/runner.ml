open Compiler

type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined
  | VBoolean of bool
  | VAddress of int (* byte address *)
[@@deriving show]

type vm_error = TypeError of string [@@deriving show]

type t = {
  heap : Heap.t;
  pc : int ref;
  os : int list ref;
  env_addr : int ref;
  rts : int list ref;
}

let string_of_vm_value = show_vm_value
let string_of_vm_error = show_vm_error

let create () =
  let initial_state =
    {
      heap = Heap.create;
      pc = ref 0;
      os = ref [];
      env_addr = ref 0;
      rts = ref [];
    }
  in
  Printf.printf "initialized pc: %d\n" !(initial_state.pc);
  initial_state

let vm_value_of_address state addr =
  let heap = state.heap in
  match Heap.heap_get_tag heap addr with
  | Number_tag ->
      let n = Heap.heap_get_number_value heap addr in
      VNumber (Int.of_float n)
  | String_tag ->
      let s = Heap.heap_get_string_value heap addr in
      VString s
  | Undefined_tag -> VUndefined
  | _ -> failwith "Unexpected tag"

(* PC is modified by the caller, this function only modifies the rest: heap, os, env_addr *)
let pop_stack stack_ref =
  match !stack_ref with
  | hd :: tl ->
      stack_ref := tl;
      Ok hd
  | [] -> Error (TypeError "Stack underflow")

(** Execute a single VM instruction *)
let execute_instruction state instr =
  let heap = state.heap in
  let env_addr = !(state.env_addr) in
  let os = !(state.os) in

  match instr with
  | DONE -> (
      match !(state.os) with
      | [] -> Ok VUndefined
      | ops -> Ok (List.hd ops |> vm_value_of_address state))
  | ENTER_SCOPE { num } ->
      let new_blockframe_addr = Heap.heap_allocate_blockframe heap ~env_addr in
      state.rts := new_blockframe_addr :: !(state.rts);

      let new_frame_addr =
        Heap.heap_allocate heap ~size:num ~tag:Heap.Frame_tag
      in
      Heap.heap_set_frame_children_to_unassigned heap ~frame_addr:new_frame_addr
        ~num_children:num;

      state.env_addr := Heap.heap_env_extend heap ~new_frame_addr;
      Ok VUndefined
      (* The value is not actually used. Only to signal that there's no error *)
  | EXIT_SCOPE ->
      let blockframe_addr = List.hd !(state.rts) in
      state.env_addr := Heap.heap_get_blockframe_env heap blockframe_addr;
      Ok VUndefined
  | LDC lit_value ->
      let value_addr = Heap.heap_allocate_value heap lit_value in
      state.os := value_addr :: os;
      Ok VUndefined
  | ASSIGN pos ->
      let val_addr = List.hd !(state.os) in
      Heap.heap_set_env_val_addr_at_pos heap ~env_addr
        ~frame_index:pos.frame_index ~val_index:pos.value_index ~val_addr;
      Ok VUndefined
  | LD { sym = _; pos } ->
      let value_addr =
        Heap.heap_get_env_val_addr_at_pos heap ~env_addr
          ~frame_index:pos.frame_index ~val_index:pos.value_index
      in
      state.os := value_addr :: !(state.os);
      Ok VUndefined
  | RESET -> (
      match !(state.rts) with
      | [] -> Error (TypeError "Runtime stack empty during RESET")
      | frame_addr :: rest ->
          state.rts := rest;
          if Heap.is_callframe heap frame_addr then (
            let reset_pc = Heap.heap_get_callframe_pc heap frame_addr in
            let reset_env_addr = Heap.heap_get_callframe_env heap frame_addr in
            state.pc := reset_pc;
            state.env_addr := reset_env_addr;
            Ok VUndefined)
          else Ok VUndefined)
  | POP -> (
      match pop_stack state.os with Ok _ -> Ok VUndefined | Error e -> Error e)
  | other ->
      Error
        (TypeError
           (Printf.sprintf "Unrecognized instruction %s"
              (Compiler.string_of_instruction other)))

(** Main VM execution loop *)
let run state instrs =
  let rec run_helper state =
    let pc = !(state.pc) in
    Printf.printf "pc:%d\n" pc;

    match List.nth_opt instrs pc with
    | None -> Error (TypeError (Printf.sprintf "Invalid program counter:%d" pc))
    | Some instr -> (
        match execute_instruction state instr with
        | Ok res -> (
            state.pc := pc + 1;
            Printf.printf "instr:%s" (string_of_instruction instr);
            match instr with DONE -> Ok res | _ -> run_helper state)
        | Error e -> Error e (* Early exit in case of error *))
  in
  run_helper state
