open Vm.Type_checker

let test_literal_mismatch_fails () =
  let tc = create () in
  let node =
    Vm.Ast.Let { sym = "x"; declared_type = TBoolean; expr = Literal (Int 1) }
  in
  let result = check_type node tc in
  let expected =
    Error "Type error: expected Types.TBoolean but got Types.TInt"
  in

  Alcotest.(check (result unit string)) "test" expected result

let test_match_int_succeeds () =
  let tc = create () in
  let node =
    Vm.Ast.Let { sym = "x"; declared_type = TInt; expr = Literal (Int 1) }
  in
  let actual = check_type node tc in
  let expected = Ok () in
  Alcotest.(check (result unit string)) "test" expected actual

let () =
  let open Alcotest in
  run "Type checker Tests"
    [
      ( "Type checker",
        [
          test_case "Literal int" `Quick test_literal_mismatch_fails;
          test_case "Literal int pass" `Quick test_match_int_succeeds;
        ] );
    ]
