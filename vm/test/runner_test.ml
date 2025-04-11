open Vm.Runner

let pp_value fmt v = Format.pp_print_string fmt (string_of_vm_value v)
let testable_value = Alcotest.testable pp_value ( = )
let pp_error fmt e = Format.pp_print_string fmt (string_of_vm_error e)
let testable_error = Alcotest.testable pp_error ( = )

let check_vm_value msg expected actual =
  Alcotest.(check (result testable_value testable_error)) msg expected actual

(* ---------- Test cases ---------- *)

let test_run_ldc () =
  let open Vm.Compiler in
  let instrs = [ LDC (Int 123); DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "run ldc int" (Ok (VNumber 123)) result

let test_assign_and_ld () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 1 };
      (* scope for y *)
      LDC (Int 4);
      (* push 4 *)
      ASSIGN { frame_index = 0; value_index = 0; };
      (* assign to y *)
      EXIT_SCOPE;
      (* exit x scope *)
      DONE;
    ]
  in
  let result = run (create ()) instrs in
  check_vm_value "run assign and load" (Ok (VNumber 4)) result

let test_run_string_literal () =
  let open Vm.Compiler in
  let instrs = [ LDC (String "hello world"); DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "run ldc string" (Ok (VString "hello world")) result

let test_enter_exit_scope () =
  let open Vm.Compiler in
  let instrs = [ ENTER_SCOPE { num = 2 }; EXIT_SCOPE; DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "enter/exit scope should succeed" (Ok VUndefined) result

let test_run_empty_stack () =
  let open Vm.Compiler in
  let instrs = [ DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "empty operand stack" (Ok VUndefined) result

let test_unrecognized_instr () =
  let open Vm.Compiler in
  (* We inject an instruction the VM doesn't yet handle, like BINOP *)
  let instrs = [ BINOP { sym = "+" }; DONE ] in
  let result = run (create ()) instrs in
  match result with
  | Error (TypeError msg) ->
      Alcotest.(check bool)
        "error contains BINOP" true (String.contains msg 'B')
  | _ -> Alcotest.fail "Expected TypeError for unsupported BINOP"

(* ---------- Run tests ---------- *)

let () =
  let open Alcotest in
  run "VM Runner Tests"
    [
      ( "runner",
        [
          test_case "Run LDC Int" `Quick test_run_ldc;
          test_case "Run LDC String" `Quick test_run_string_literal;
          test_case "Enter/Exit Scope" `Quick test_enter_exit_scope;
          test_case "DONE on empty stack" `Quick test_run_empty_stack;
          test_case "Unrecognized instruction" `Quick test_unrecognized_instr;
          test_case "assign and load" `Quick test_assign_and_ld;
        ] );
    ]
