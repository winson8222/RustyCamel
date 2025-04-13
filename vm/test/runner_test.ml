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
  check_vm_value "run ldc int" (Ok (VNumber 123.0)) result

let test_binop_arithmetic () =
  let open Vm.Compiler in
  let test_cases =
    [
      (* Addition *)
      ( [ LDC (Int 6); LDC (Int 4); BINOP Add; DONE ],
        Ok (VNumber 10.0),
        "addition test" );
      (* Subtraction *)
      ( [ LDC (Int 10); LDC (Int 4); BINOP Subtract; DONE ],
        Ok (VNumber 6.0),
        "subtraction test" );
      (* Multiplication *)
      ( [ LDC (Int 5); LDC (Int 4); BINOP Multiply; DONE ],
        Ok (VNumber 20.0),
        "multiplication test" );
      (* Division *)
      ( [ LDC (Int 10); LDC (Int 2); BINOP Divide; DONE ],
        Ok (VNumber 5.0),
        "division test" );
    ]
  in
  List.iter
    (fun (instrs, expected, msg) ->
      let result = run (create ()) instrs in
      check_vm_value msg expected result)
    test_cases

let test_binop_comparison () =
  let open Vm.Compiler in
  let test_cases =
    [
      (* Less Than *)
      ( [ LDC (Int 4); LDC (Int 6); BINOP LessThan; DONE ],
        Ok (VBoolean true),
        "less than true test" );
      ( [ LDC (Int 6); LDC (Int 4); BINOP LessThan; DONE ],
        Ok (VBoolean false),
        "less than false test" );
      (* Less Than Equal *)
      ( [ LDC (Int 4); LDC (Int 4); BINOP LessThanEqual; DONE ],
        Ok (VBoolean true),
        "less than equal same value test" );
      ( [ LDC (Int 6); LDC (Int 4); BINOP LessThanEqual; DONE ],
        Ok (VBoolean false),
        "less than equal false test" );
      (* Greater Than *)
      ( [ LDC (Int 6); LDC (Int 4); BINOP GreaterThan; DONE ],
        Ok (VBoolean true),
        "greater than true test" );
      ( [ LDC (Int 4); LDC (Int 6); BINOP GreaterThan; DONE ],
        Ok (VBoolean false),
        "greater than false test" );
      (* Greater Than Equal *)
      ( [ LDC (Int 4); LDC (Int 4); BINOP GreaterThanEqual; DONE ],
        Ok (VBoolean true),
        "greater than equal same value test" );
      ( [ LDC (Int 4); LDC (Int 6); BINOP GreaterThanEqual; DONE ],
        Ok (VBoolean false),
        "greater than equal false test" );
    ]
  in
  List.iter
    (fun (instrs, expected, msg) ->
      let result = run (create ()) instrs in
      check_vm_value msg expected result)
    test_cases

let test_binop_equality () =
  let open Vm.Compiler in
  let test_cases =
    [
      (* Equal - Numbers *)
      ( [ LDC (Int 4); LDC (Int 4); BINOP Equal; DONE ],
        Ok (VBoolean true),
        "equal numbers true test" );
      ( [ LDC (Int 4); LDC (Int 5); BINOP Equal; DONE ],
        Ok (VBoolean false),
        "equal numbers false test" );
      (* Equal - Booleans *)
      ( [ LDC (Boolean true); LDC (Boolean true); BINOP Equal; DONE ],
        Ok (VBoolean true),
        "equal booleans true test" );
      ( [ LDC (Boolean true); LDC (Boolean false); BINOP Equal; DONE ],
        Ok (VBoolean false),
        "equal booleans false test" );
      (* Equal - Strings *)
      ( [ LDC (String "hello"); LDC (String "hello"); BINOP Equal; DONE ],
        Ok (VBoolean true),
        "equal strings true test" );
      ( [ LDC (String "hello"); LDC (String "world"); BINOP Equal; DONE ],
        Ok (VBoolean false),
        "equal strings false test" );
      (* Not Equal *)
      ( [ LDC (Int 4); LDC (Int 5); BINOP NotEqual; DONE ],
        Ok (VBoolean true),
        "not equal true test" );
      ( [ LDC (Int 4); LDC (Int 4); BINOP NotEqual; DONE ],
        Ok (VBoolean false),
        "not equal false test" );
    ]
  in
  List.iter
    (fun (instrs, expected, msg) ->
      let result = run (create ()) instrs in
      check_vm_value msg expected result)
    test_cases

let test_unop_negate () =
  let open Vm.Compiler in
  let instrs = [ LDC (Int 6); UNOP Negate; DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "run ldc int" (Ok (VNumber (-6.0))) result

let test_unop_not () =
  let open Vm.Compiler in
  let instrs = [ LDC (Boolean false); UNOP LogicalNot; DONE ] in
  let result = run (create ()) instrs in
  check_vm_value "test_unop_not" (Ok (VBoolean true)) result

let test_borrow () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 2 };
      LDC (String "hello");
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      BORROW;
      ASSIGN { frame_index = 0; value_index = 1 };
      LD { pos = { frame_index = 0; value_index = 1 } };
      EXIT_SCOPE;
      DONE;
    ]
  in
  let result = run (create ()) instrs in
  check_vm_value "borrow" (Ok (VRef (VString "hello"))) result

let test_borrow_and_deref () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 2 };
      LDC (String "hello");
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      BORROW;
      ASSIGN { frame_index = 0; value_index = 1 };
      LD { pos = { frame_index = 0; value_index = 1 } };
      DEREF;
      EXIT_SCOPE;
      DONE;
    ]
  in
  let result = run (create ()) instrs in
  check_vm_value "borrow" (Ok (VString "hello")) result

let test_assign_and_ld () =
  let open Vm.Compiler in
  let instrs =
    [
      ENTER_SCOPE { num = 1 };
      (* scope for y *)
      LDC (Int 4);
      (* push 4 *)
      ASSIGN { frame_index = 0; value_index = 0 };
      (* assign to y *)
      EXIT_SCOPE;
      (* exit x scope *)
      DONE;
    ]
  in
  let result = run (create ()) instrs in
  check_vm_value "run assign and load" (Ok (VNumber 4.0)) result

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

let () =
  let open Alcotest in
  run "VM Runner Tests"
    [
      ( "runner",
        [
          test_case "test_unop_not" `Quick test_unop_not;
          test_case "Run LDC Int" `Quick test_run_ldc;
          test_case "test_binop_arithmetic" `Quick test_binop_arithmetic;
          test_case "test_binop_comparison" `Quick test_binop_comparison;
          test_case "test_binop_equality" `Quick test_binop_equality;
          test_case "test_unop_negate" `Quick test_unop_negate;
          test_case "Run LDC String" `Quick test_run_string_literal;
          test_case "Enter/Exit Scope" `Quick test_enter_exit_scope;
          test_case "DONE on empty stack" `Quick test_run_empty_stack;
          test_case "assign and load" `Quick test_assign_and_ld;
          test_case "borrow" `Quick test_borrow;
          test_case "borrow_and_deref" `Quick test_borrow_and_deref;
        ] );
    ]
