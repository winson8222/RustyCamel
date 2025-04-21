open Vm.Runner

let pp_value fmt v = Format.pp_print_string fmt (string_of_vm_value v)
let testable_value = Alcotest.testable pp_value ( = )
let pp_error fmt e = Format.pp_print_string fmt (string_of_vm_error e)
let testable_error = Alcotest.testable pp_error ( = )

let check_vm_value msg expected actual =
  Alcotest.(check (result testable_value testable_error)) msg expected actual


(* let test_function_definition_and_execution () =
  let open Vm.Compiler in
  let instrs = [
    ENTER_SCOPE { num = 1 };  (* Scope for function *)
    LDF { arity = 2; addr = 3 };  (* Function with 2 parameters *)
    GOTO 11;  (* Skip function body *)
    ENTER_SCOPE { num = 0 };  (* Function scope *)
    LD { pos = { frame_index = 1; value_index = 0 } };  (* Load first param *)
    LD { pos = { frame_index = 1; value_index = 1 } };  (* Load second param *)
    BINOP Add;  (* Add them *)
    RESET;  (* Return from function *)
    EXIT_SCOPE;  (* Exit function scope *)
    LDC Undefined;  (* After function definition *)
    RESET;  (* Return to main scope *)
    ASSIGN { frame_index = 0; value_index = 0 };  (* Store function *)
    EXIT_SCOPE;  (* Exit main scope *)
    DONE;
  ] in

  (* First run to get the closure *)
  let result = run (create ()) instrs in
  check_vm_value "function definition and execution" (Ok (VClosure (2, 3, 70))) result *)

(* let test_function_call_with_args () =
  let open Vm.Compiler in
  let instrs = [
    ENTER_SCOPE { num = 1 };  (* Scope for function *)
    LDF { arity = 2; addr = 3 };  (* Function with 2 parameters *)
    GOTO 11;  (* Skip function body *)
    ENTER_SCOPE { num = 0 };  (* Function scope *)
    LD { pos = { frame_index = 1; value_index = 0 } };  (* Load first param *)
    LD { pos = { frame_index = 1; value_index = 1 } };  (* Load second param *)
    BINOP Add;  (* Add them *)
    RESET;  (* Return from function *)
    EXIT_SCOPE;  (* Exit function scope *)
    LDC Undefined;  (* After function definition *)
    RESET;  (* Return to main scope *)
    ASSIGN { frame_index = 0; value_index = 0 };  (* Store function *)
    POP;  (* Clean up stack *)
    LD { pos = { frame_index = 0; value_index = 0 } };  (* Load function *)
    LDC (Int 33);  (* First argument *)
    LDC (Int 22);  (* Second argument *)
    CALL 2;  (* Call function with 2 arguments *)
    EXIT_SCOPE;  (* Exit main scope *)
      DONE;
  ] in

  let result = run (create ()) instrs in
  check_vm_value "function call with arguments" (Ok (VNumber 55.0)) result *)

let test_factorial () =
  let open Vm.Compiler in
  let instrs = [
    ENTER_SCOPE { num = 1 };  (* Scope for factorial function *)
    LDF { arity = 1; addr = 3 };  (* Function with 1 parameter *)
    GOTO 26;  (* Skip function body *)
    ENTER_SCOPE { num = 0 };  (* Function scope *)
    LD { pos = { frame_index = 2; value_index = 0 } };  (* Load n *)
    LDC (Int 0);  (* Load 0 *)
    BINOP Equal;  (* n == 0 *)
    JOF 13;  (* If false, jump to recursive case *)
    ENTER_SCOPE { num = 0 };  (* Base case scope *)
    LDC (Int 1);  (* Return 1 *)
    RESET;  (* Return from base case *)
    EXIT_SCOPE;  (* Exit base case scope *)
    GOTO 23;  (* Skip recursive case *)
    ENTER_SCOPE { num = 0 };  (* Recursive case scope *)
    LD { pos = { frame_index = 2; value_index = 0 } };  (* Load n *)
    LD { pos = { frame_index = 1; value_index = 0 } };  (* Load n-1 *)
    LD { pos = { frame_index = 2; value_index = 0 } };  (* Load n *)
    LDC (Int 1);  (* Load 1 *)
    BINOP Subtract;  (* n - 1 *)
    CALL 1;  (* Call factorial(n-1) *)
    BINOP Multiply;  (* n * factorial(n-1) *)
    RESET;  (* Return from recursive case *)
    EXIT_SCOPE;  (* Exit recursive case scope *)
    EXIT_SCOPE;  (* Exit function scope *)
    LDC Undefined;  (* After function definition *)
    RESET;  (* Return to main scope *)
    ASSIGN { frame_index = 1; value_index = 0 };  (* Store factorial function *)
    POP;  (* Clean up stack *)
    LD { pos = { frame_index = 1; value_index = 0 } };  (* Load factorial function *)
    LDC (Int 4);  (* Argument 4 *)
    CALL 1;  (* Call factorial(4) *)
    EXIT_SCOPE;  (* Exit main scope *)
    DONE;  (* End program *)
  ] in

  let result = run (create ()) instrs in
  check_vm_value "factorial of 4" (Ok (VNumber 24.0)) result

let test_simple_function_return_param () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 1; addr = 3 };
      (* Function with 1 parameter *)
      GOTO 9;
      (* Skip function body *)
      ENTER_SCOPE { num = 0 };
      (* Function scope *)
      LD { pos = { frame_index = 2; value_index = 0 } };
      (* Load parameter *)
      RESET;
      (* Return from function *)
      EXIT_SCOPE;
      (* Exit function scope *)
      LDC Undefined;
      (* After function definition *)
      RESET;
      (* Return to main scope *)
      ASSIGN { frame_index = 1; value_index = 0 };
      (* Store function *)
      POP;
      (* Clean up stack *)
      LD { pos = { frame_index = 1; value_index = 0 } };
      (* Load function *)
      LDC (Int 1);
      (* Argument *)
      CALL 1;
      (* Call function with 1 argument *)
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      (* Exit main scope *)
      DONE;
    ]
  in

  let result = run (create ()) instrs in
  check_vm_value "simple function that returns its parameter" (Ok (VNumber 1.0))
    result

let test_simple_free () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 1);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      LDC (Int 2);
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      LDC (Int 3);
      ASSIGN { frame_index = 0; value_index = 2 };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = false };
      DONE;
    ]
  in

  let result = run (create ()) instrs in
  check_vm_value "simple free" (Ok (VNumber 3.0)) result

let test_function_return_one () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 2 };
      (* Scope for function and result *)
      LDF { arity = 0; addr = 3 };
      (* Function with 0 parameters *)
      GOTO 12;
      (* Skip function body *)
      ENTER_SCOPE { num = 1 };
      (* Function scope *)
      LDC (Int 1);
      (* Load 1 *)
      ASSIGN { frame_index = 2; value_index = 0 };
      (* Assign to local variable *)
      POP;
      (* Clean up stack *)
      LD { pos = { frame_index = 2; value_index = 0 } };
      (* Load the value *)
      RESET;
      (* Return from function *)
      EXIT_SCOPE;
      (* Exit function scope *)
      LDC Undefined;
      (* After function definition *)
      RESET;
      (* Return to main scope *)
      ASSIGN { frame_index = 1; value_index = 0 };
      (* Store function *)
      POP;
      (* Clean up stack *)
      LD { pos = { frame_index = 1; value_index = 0 } };
      (* Load function *)
      CALL 0;
      (* Call function with 0 arguments *)
      ASSIGN { frame_index = 1; value_index = 1 };
      LD { pos = { frame_index = 1; value_index = 1 } };
      (* Store result *)
      EXIT_SCOPE;
      (* Exit main scope *)
      DONE;
      (* End program *)
    ]
  in

  let result = run (create ()) instrs in
  check_vm_value "function that returns 1" (Ok (VNumber 1.0)) result

let () =
  let open Alcotest in
  run "VM Runner Tests"
    [
      ( "runner",
        [
          test_case "factorial of 5" `Quick test_factorial;
          test_case "simple function that returns its parameter" `Quick
            test_simple_function_return_param;
          test_case "simple free" `Quick test_simple_free;
          test_case "function that returns 1" `Quick test_function_return_one;
        ] );
    ]
