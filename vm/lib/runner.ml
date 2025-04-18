open Compiler

type vm_value =
  | VNumber of float
  | VString of string
  | VUndefined
  | VBoolean of bool
  | VRef of vm_value
  | VAddress of int (* byte address *)
  | VClosure of int * int * int
  | VFrame of int
  | VEnvironment of int (* TODO : Remove *)
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
      heap = Heap.create ();
      pc = ref 0;
      os = ref [];
      env_addr = ref 40;
      (* temp *)
      rts = ref [];
    }
  in
  (* Printf.printf "initialized pc: %d\n" !(initial_state.pc); *)
  initial_state

let rec vm_value_of_address heap addr =
  let tag = Heap.heap_get_tag heap addr |> Heap.string_of_node_tag in
  Printf.printf "vm_value_of_address: %d\n" addr;
  Printf.printf "tag: %s\n" tag;
  match Heap.heap_get_tag heap addr with
  | Number_tag ->
      let n = Heap.heap_get_number_value heap addr in
      VNumber n
  | String_tag ->
      let s = Heap.heap_get_string_value heap addr in
      VString s
  | Ref_tag ->
      let v = Heap.heap_get_ref_value heap addr in
      VRef (vm_value_of_address heap v)
  | Undefined_tag -> VUndefined
  | False_tag -> VBoolean false
  | True_tag -> VBoolean true
  | Closure_tag ->
      let arity = Heap.heap_get_closure_arity heap addr in
      let code_addr = Heap.heap_get_closure_code_addr heap addr in
      let env_addr = Heap.heap_get_closure_env_addr heap addr in
      VClosure (arity, code_addr, env_addr)
  | Frame_tag ->
      let num_children = Heap.heap_get_num_children heap addr in
      VFrame num_children
  | Environment_tag ->
      let num_children = Heap.heap_get_num_children heap addr in
      VEnvironment num_children
  | Blockframe_tag ->
      (* Printf.printf "Blockframe tag\n"; *)
      VUndefined
  | tag ->
      failwith
        (Printf.sprintf "Unexpected tag: %s" (Heap.string_of_node_tag tag))

(* PC is modified by the caller, this function only modifies the rest: heap, os, env_addr *)
let pop_stack stack_ref =
  match !stack_ref with
  | hd :: tl ->
      stack_ref := tl;
      Ok hd
  | [] -> Error (TypeError "Stack underflow")

let rec vm_value_to_address (heap : Heap.t) (value : vm_value) : int =
  match value with
  | VNumber n -> Heap.heap_allocate_number heap n
  | VString s -> Heap.heap_allocate_string heap s
  | VBoolean b ->
      if b then Heap.heap_get_true heap else Heap.heap_get_false heap
  | VUndefined -> Heap.heap_get_undefined heap
  | VRef v ->
      let addr = vm_value_to_address heap v in
      Heap.heap_allocate_ref heap (Float.of_int addr)
  | VAddress addr -> addr
  | other ->
      Printf.sprintf "Unexpected value: %s" (show_vm_value other) |> failwith

let apply_unop ~op state =
  let os = !(state.os) in
  let heap = state.heap in
  let operand = List.hd os |> vm_value_of_address heap in

  let res_addr =
    match op with
    | Ast.LogicalNot -> (
        match operand with
        | VBoolean b -> VBoolean (not b) |> vm_value_to_address heap
        | other ->
            failwith
              (Printf.sprintf "unexpected type for unary not: %s"
                 (show_vm_value other)))
    | Negate -> (
        match operand with
        | VNumber n -> VNumber (Float.mul (-1.0) n) |> vm_value_to_address heap
        | _ -> failwith "wrong")
  in
  state.os := res_addr :: List.tl os

let apply_binop ~op state =
  let os = !(state.os) in
  let heap = state.heap in
  (* Printf.printf "os element head: %s\n"
    (show_vm_value (List.hd os |> vm_value_of_address heap));
  Printf.printf "os element tail: %s\n"
    (show_vm_value (List.hd (List.tl os) |> vm_value_of_address heap)); *)

  let scnd = List.hd os |> vm_value_of_address heap in
  let frst = List.nth os 1 |> vm_value_of_address heap in

  let compute_number_op op =
    match op with
    | Ast.Add -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VNumber (Float.add n1 n2)
        | _ ->
            failwith
              (Printf.sprintf
                 "Addition requires number operands. Instead received %s and %s"
                 (show_vm_value frst) (show_vm_value scnd)))
    | Subtract -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VNumber (Float.sub n1 n2)
        | _ -> failwith "Subtraction requires integer operands")
    | Multiply -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VNumber (Float.mul n1 n2)
        | _ -> failwith "Multiplication requires matching numeric operands")
    | Divide -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VNumber (Float.div n1 n2)
        | _ -> failwith "Division requires float operands")
    | _ -> failwith "Not number operation"
  in

  let compute_comparison = function
    | Ast.LessThan -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 < n2)
        | _ -> failwith "Comparison requires matching numeric operands")
    | LessThanEqual -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 <= n2)
        | _ -> failwith "Comparison requires matching numeric operands")
    | GreaterThanEqual -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 >= n2)
        | _ -> failwith "Comparison requires matching numeric operands")
    | GreaterThan -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 > n2)
        | _ -> failwith "Comparison requires matching numeric operands")
    | Equal -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 = n2)
        | VBoolean b1, VBoolean b2 -> VBoolean (b1 = b2)
        | VString s1, VString s2 -> VBoolean (String.equal s1 s2)
        | VUndefined, VUndefined -> VBoolean true
        | _ -> VBoolean false)
    | NotEqual -> (
        match (frst, scnd) with
        | VNumber n1, VNumber n2 -> VBoolean (n1 <> n2)
        | VBoolean b1, VBoolean b2 -> VBoolean (b1 <> b2)
        | VString s1, VString s2 -> VBoolean (not (String.equal s1 s2))
        | VUndefined, VUndefined -> VBoolean false
        | _ -> VBoolean true)
    | _ -> failwith "Unsupported comparison operator"
  in

  let res_value =
    match op with
    | Ast.Add | Subtract | Multiply | Divide -> compute_number_op op
    | LessThan | LessThanEqual | GreaterThan | GreaterThanEqual | Equal
    | NotEqual ->
        compute_comparison op
  in

  let res_addr = vm_value_to_address heap res_value in
  (* Printf.printf "res_addr: %d\n" res_addr; *)
  (* Printf.printf "os after pop: ["; *)
  state.os := res_addr :: List.tl (List.tl os)

(** Execute a single VM instruction *)
let execute_instruction state instr =
  (* Heap.pretty_print_heap state.heap ; *)
  (* heap_environment_display state.heap  !(state.env_addr); *)
  let heap = state.heap in
  let env_addr = !(state.env_addr) in
  let os = !(state.os) in

  (* print the instruction *)
  Printf.printf "Executing instruction: %s\n" (Compiler.string_of_instruction instr);

  (* Printf.printf "OS: ["; *)
  (* List.iter (fun addr -> Printf.printf "%d; " addr) os; *)
  (* Printf.printf "]\n"; *)

  (* Printf.printf "env_addr: %d\n" env_addr; *)
  (* Printf.printf "rts: ["; *)
  (* List.iter (fun addr -> Printf.printf "%d; " addr) !(state.rts); *)
  (* Printf.printf "]\n"; *)
  match instr with
  | DONE -> (
      match !(state.os) with
      | [] -> Ok VUndefined
      | ops -> Ok (List.hd ops |> vm_value_of_address state.heap))
  | ENTER_SCOPE { num } ->
      let new_blockframe_addr = Heap.heap_allocate_blockframe heap ~env_addr in
      state.rts := new_blockframe_addr :: !(state.rts);
      (* Printf.printf "RTS after ENTER_SCOPE: ["; *)
      (* List.iter (fun addr -> Printf.printf "%d; " addr) !(state.rts); *)

      (* Printf.printf "]\n"; *)
      (* Printf.printf "num: %d\n" num; *)
      let new_frame_addr = Heap.heap_allocate_frame heap ~num_values:num in
      Heap.heap_set_frame_children_to_unassigned heap ~frame_addr:new_frame_addr
        ~num_children:num;

      (* print the new frame address *)
      state.env_addr :=
        Heap.heap_env_extend heap ~env_addr:!(state.env_addr) ~new_frame_addr;
      Ok VUndefined
      (* The value is not actually used. Only to signal that there's no error *)
  | EXIT_SCOPE ->
      let blockframe_addr = List.hd !(state.rts) in
      state.env_addr := Heap.heap_get_blockframe_env heap blockframe_addr;
      Ok VUndefined
  | LDC lit_value ->
      (* Printf.printf "LDC: %s\n" (Types.show_lit_value lit_value); *)
      let value_addr = Heap.heap_allocate_value heap lit_value in
      state.os := value_addr :: os;
      Ok VUndefined
  | ASSIGN pos ->
      (* Printf.printf "OS len: %d\n" (List.length !(state.os)); *)
      let val_addr = List.hd !(state.os) in
      (* Printf.printf "val: %s val_addr: %d\n"
        (show_vm_value (vm_value_of_address heap val_addr))
        val_addr; *)
      Heap.heap_set_env_val_addr_at_pos heap ~env_addr
        ~frame_index:pos.frame_index ~val_index:pos.value_index ~val_addr;
      Ok VUndefined
  | LD { pos; _ } ->
      (* print the positions *)
      (* Printf.printf "pos frame index: %d\n" pos.frame_index;
      Printf.printf "pos value index: %d\n" pos.value_index; *)

      (* print the environment address *)

      (* 1. Get current environment address *)
      let value_addr =
        Heap.heap_get_env_val_addr_at_pos heap ~env_addr
          ~frame_index:pos.frame_index ~val_index:pos.value_index
      in

      (* print the value address *)

      (* print the value *)

      (* print the type of the value address *)
      (* let tag = Heap.heap_get_tag heap value_addr in *)
      (* Printf.printf "LD got tag: %s" (Heap.string_of_node_tag tag);
      (match tag with
      | Heap.Number_tag ->
          let value = Heap.heap_get_number_value heap value_addr in
          Printf.printf " (value: %f)" value
      | _ -> ());
      Printf.printf "\n"; *)

      (* print the value address *)
      state.os := value_addr :: !(state.os);
      Ok VUndefined
  | LDF { arity; addr } ->
      (* 1. Get current environment address *)
      let env_addr = !(state.env_addr) in

      (* print cdoe adddress*)
      (* Printf.printf "LDF code_addr: %d\n" addr; *)

      (* print the environment address *)
      (* 2. Allocate closure with arity, code address, and environment *)
      let closure_addr =
        Heap.heap_allocate_closure state.heap ~arity ~code_addr:addr ~env_addr
      in
      (* Printf.printf "LDF closure addr: %d\n" closure_addr;
      Printf.printf "LDF closure pc: %d\n"
        (Heap.heap_get_closure_code_addr state.heap closure_addr); *)

      (* print the environment address *)

      (* print the closure address *)
      (* Printf.printf "closure_addr: %d\n" closure_addr; *)

      (* 3. Push closure address to operand stack *)
      state.os := closure_addr :: !(state.os);

      (* Printf.printf "OS: ["; *)

      (* print the type of the value address *)
      Ok VUndefined
  | RESET -> (
      (* pc - 1*)
      match !(state.rts) with
      | [] -> Error (TypeError "Runtime stack empty during RESET")
      | frame_addr :: rest ->
          state.rts := rest;
          if Heap.is_callframe heap frame_addr then (
            let reset_pc = Heap.heap_get_callframe_pc heap frame_addr in
            let reset_env_addr = Heap.heap_get_callframe_env heap frame_addr in
            state.env_addr := reset_env_addr;

            (* Printf.printf "RESET addr: %d\n" reset_pc; *)
            Ok (VAddress (reset_pc + 1)))
          else Ok (VAddress !(state.pc)))
  | POP -> (
      match pop_stack state.os with Ok _ -> Ok VUndefined | Error e -> Error e)
  | UNOP op ->
      apply_unop ~op state;
      Ok VUndefined
  | BINOP op ->
      (* print the entire heap *)
      apply_binop ~op state;
      Ok VUndefined
  | BORROW ->
      let operand_addr = Float.of_int (List.hd os) in
      let addr = Heap.heap_allocate_ref state.heap operand_addr in
      state.os := addr :: List.tl os;
      Ok VUndefined
  | DEREF ->
      let operand_addr = List.hd os in
      let value_addr = Heap.heap_get_ref_value state.heap operand_addr in
      state.os := value_addr :: List.tl os;
      Ok VUndefined
  | FREE { pos; to_free } ->
      (* if not to_free, just do nothing *)
      if not to_free then Ok VUndefined
      else (
        Heap.heap_free_at_pos heap ~env_addr ~frame_index:pos.frame_index
          ~val_index:pos.value_index;
        Ok VUndefined)
  | JOF addr ->
      (* 1. Pop boolean value from operand stack *)
      let bool_addr = List.hd os in
      let is_true = Heap.heap_get_bool_value state.heap bool_addr in

      (* Printf.printf "JOF bool_addr: %d\n" bool_addr; *)

      (* 2. Update PC based on boolean value *)
      if is_true then
        state.pc := !(state.pc) + 1 (* Continue to next instruction *)
      else state.pc := addr;

      (* Jump to target address *)

      (* 3. Update operand stack *)
      state.os := List.tl os;

      if is_true then Ok (VAddress !(state.pc)) else Ok (VAddress addr)
  | GOTO addr ->
      (* Simply set PC to target address *)
      state.pc := addr;
      (* Printf.printf "OS len: %d\n" (List.length !(state.os)); *)

      Ok (VAddress addr)
  | CALL arity ->
      (* print the operand stack *)
      (* Printf.printf "before os: ["; *)
      (* List.iter (fun addr -> Printf.printf "%d; " addr) !(state.os); *)

      (* Printf.printf "]\n"; *)

      (* 1. Get the function from the top n of the operand stack *)
      let fun_addr = List.nth !(state.os) arity in

      (* print the address of the function *)
      (* Printf.printf "fun_addr: %d\n" fun_addr; *)
      (* 2. Check if it's a builtin *)
      if Heap.heap_get_tag state.heap fun_addr = Heap.Builtin_tag then
        (* let builtin_id = Heap.heap_get_builtin_id state.heap fun_addr in *)
        (* TODO: Implement apply_builtin *)
        failwith "Builtin functions not implemented yet"
      else
        (* 3. Allocate frame for arguments *)
        let frame_addr =
          Heap.heap_allocate_frame state.heap ~num_values:arity
        in

        (* print the frame address *)
        (* Printf.printf "[call] frame address: %d\n" frame_addr; *)
        (* Printf.printf "[call] num frame vals: %d\n" (Heap.heap_get_num_children state.heap frame_addr); *)
        (* 4. Pop arguments from operand stack and set them in the frame *)
        let rec set_args i =
          if i < 0 then ()
          else
            let arg_addr = List.hd !(state.os) in
            (* Printf.printf "setting child %d to %d\n" i arg_addr; *)
            state.os := List.tl !(state.os);
            (* Printf.printf "arg_addr: %d\n" arg_addr; *)
            Heap.heap_set_child state.heap ~address:frame_addr ~child_index:i
              ~value:(Float.of_int arg_addr);
            set_args (i - 1)
        in
        set_args (arity - 1);

        (* print the frame adn values of the args *)

        (* 5. Pop the function *)
        state.os := List.tl !(state.os);

        (* 6. Push callframe to runtime stack *)
        let callframe_addr =
          Heap.heap_allocate_callframe state.heap ~pc:!(state.pc)
            ~env_addr:!(state.env_addr)
        in

        (* print the size of the callframe *)
        state.rts := callframe_addr :: !(state.rts);

        (* 7. Update environment *)
        let closure_env = Heap.heap_get_closure_env_addr state.heap fun_addr in

        (* print the closure env *)
        state.env_addr :=
          Heap.heap_env_extend state.heap ~new_frame_addr:frame_addr
            ~env_addr:closure_env;

        (* 8. Update PC to function's code address *)
        let closure_code_addr =
          Heap.heap_get_closure_code_addr state.heap fun_addr
        in
        (* AT call the address is *)
        (* Printf.printf "[CALL] closure PC is %d\n" closure_code_addr; *)

        (* Printf.printf "OS len: %d\n" (List.length !(state.os)); *)
        (* Printf.printf "OS after call: ["; *)
        Ok (VAddress closure_code_addr)
  | other ->
      Error
        (TypeError
           (Printf.sprintf "Unrecognized instruction %s"
              (Compiler.string_of_instruction other)))

(** Main VM execution loop *)
let run state instrs =
  let rec run_helper state =
    let pc = !(state.pc) in
    (* Printf.printf "pc:%d\n" pc; *)

    (* Printf.printf "env_addr: %d\n" !(state.env_addr); *)
    (* Printf.printf "rts: ["; *)

    (* Printf.printf "]\n"; *)
    (* print out the instructions *)
    (* List.iteri
      (fun i instr ->
        Printf.printf "instr[%d]: %s\n" i
          (Compiler.string_of_instruction instr))
      instrs; *)

    match List.nth_opt instrs pc with
    | None -> Error (TypeError (Printf.sprintf "Invalid program counter:%d" pc))
    | Some instr -> (
        match execute_instruction state instr with
        | Ok res -> (
            state.pc := pc + 1;
            (* print the env address *)
            (* Printf.printf "env_addr: %d\n" !(state.env_addr); *)
            (* Printf.printf "res:%s\n" (show_vm_value res); *)
            match res with
            | VAddress addr ->
                state.pc := addr;
                if instr = DONE then Ok res else run_helper state
            | _ -> if instr = DONE then Ok res else run_helper state)
        | Error e -> Error e (* Early exit in case of error *))
  in
  run_helper state
