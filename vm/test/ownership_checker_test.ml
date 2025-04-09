open Vm.Ownership_checker

let borrow_err =
  "Borrow is invalid as the variable has been moved/borrowed in other places"

let test_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        BorrowExpr { is_mutable = false; expr = Variable "x" };
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in

  Alcotest.(check (result unit string)) "test" expected result

let test_multiple_mutable_borrows_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        BorrowExpr { is_mutable = true; expr = Variable "x" };
        BorrowExpr { is_mutable = true; expr = Variable "x" };
      ]
  in
  let result = check_ownership node checker in
  let expected = Error borrow_err in

  Alcotest.(check (result unit string)) "test" expected result

let test_mut_and_immut_borrows_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        BorrowExpr { is_mutable = true; expr = Variable "x" };
        BorrowExpr { is_mutable = false; expr = Variable "x" };
      ]
  in
  let result = check_ownership node checker in
  let expected = Error borrow_err in

  Alcotest.(check (result unit string)) "test" expected result

let test_mut_and_immut_diff_scopes_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        Block
          (Sequence [ BorrowExpr { is_mutable = true; expr = Variable "x" } ]);
        Block
          (Sequence [ BorrowExpr { is_mutable = false; expr = Variable "x" } ]);
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in

  Alcotest.(check (result unit string)) "test" expected result

let test_mult_borrows_nested_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        Block
          (Sequence
             [
               BorrowExpr { is_mutable = true; expr = Variable "x" };
               Block
                 (Sequence
                    [ BorrowExpr { is_mutable = false; expr = Variable "x" } ]);
             ]);
      ]
  in
  let result = check_ownership node checker in
  let expected = Error borrow_err in

  Alcotest.(check (result unit string)) "test" expected result

let test_mult_borrows_nested_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1) };
        Block
          (Sequence
             [
               BorrowExpr { is_mutable = false; expr = Variable "x" };
               Block
                 (Sequence
                    [ BorrowExpr { is_mutable = false; expr = Variable "x" } ]);
             ]);
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in

  Alcotest.(check (result unit string)) "test" expected result

let () =
  let open Alcotest in
  run "Ownership checker Tests"
    [
      ( "Ownership checker",
        [
          test_case "Var" `Quick test_succeeds;
          test_case "fails" `Quick test_multiple_mutable_borrows_fails;
          test_case "mut and immu borrow fail" `Quick
            test_mut_and_immut_borrows_fails;
          test_case "mut and immut diff scopes success" `Quick
            test_mut_and_immut_diff_scopes_succeeds;
          test_case "mult borrows nested scoped fail" `Quick
            test_mult_borrows_nested_fails;
          test_case "mult borrows nested scoped succedd" `Quick
            test_mult_borrows_nested_succeeds;
        ] );
    ]
