open Vm.Ownership_checker

let test_simple_let_assmt_borrow_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
          };
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in
  Alcotest.(check (result unit string)) "simple borrow" expected result

let test_simple_fun_arg_borrow_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Fun { sym = "f"; body = Ret (Literal (Int 1)); prms = [ "a" ] };
        App
          {
            func = Nam "f";
            args = [ BorrowExpr { expr = Nam "x"; is_mutable = false } ];
          };
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in
  Alcotest.(check (result unit string))
    "simple borrow in function arg" expected result

let test_simple_fun_arg_move_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Fun { sym = "f"; body = Ret (Literal (Int 1)); prms = [ "a" ] };
        App { func = Nam "f"; args = [ Nam "x" ] };
      ]
  in
  let result = check_ownership node checker in
  let expected = Ok () in
  Alcotest.(check (result unit string))
    "simple move in function arg" expected result

let test_use_after_fun_arg_move_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Fun { sym = "f"; body = Ret (Literal (Int 1)); prms = [ "a" ] };
        App { func = Nam "f"; args = [ Nam "x" ] };
        Nam "x";
      ]
  in
  let result = check_ownership node checker in
  let expected = Error (make_acc_err_msg "x" Moved) in
  Alcotest.(check (result unit string))
    "use after moved into function" expected result

let test_multiple_mutable_borrows_fail () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Let
          {
            sym = "a";
            expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
            is_mutable = false;
          };
        Let
          {
            sym = "b";
            expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
            is_mutable = false;
          };
      ]
  in
  let expected = Error (make_borrow_err_msg "x" MutablyBorrowed) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "multiple mut borrows fail" expected result

let test_mutable_and_immutable_borrow_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
          };
        Let
          {
            sym = "b";
            is_mutable = false;
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
          };
      ]
  in
  let expected = Error (make_borrow_err_msg "x" MutablyBorrowed) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "mut then immut borrow fails" expected result

let test_mutable_and_immutable_in_diff_scopes_succeed () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "y";
                   expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                 };
             ]);
        Block
          (Sequence
             [
               Let
                 {
                   sym = "z";
                   expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                 };
             ]);
      ]
  in
  let expected = Ok () in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "mut and immut in blocks succeed" expected result

let test_nested_mutable_and_immutable_borrow_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "a";
                   is_mutable = false;
                   expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
                 };
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "b";
                          is_mutable = false;
                          expr =
                            BorrowExpr { is_mutable = true; expr = Nam "x" };
                        };
                    ]);
             ]);
      ]
  in
  let expected = Error (make_borrow_err_msg "x" MutablyBorrowed) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "nested mut + immut borrow fails" expected result

let test_nested_multiple_immutable_borrows_succeed () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "a";
                   is_mutable = false;
                   expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
                 };
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "b";
                          is_mutable = false;
                          expr =
                            BorrowExpr { is_mutable = false; expr = Nam "x" };
                        };
                    ]);
             ]);
      ]
  in
  let expected = Ok () in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "nested multiple immut borrows" expected result

let test_use_after_move_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Block
      (Sequence
         [
           Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
           Let { sym = "y"; expr = Nam "x"; is_mutable = false };
           Nam "x";
           (* using x after move *)
         ])
  in
  let expected = Error (make_acc_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string)) "use after move fails" expected result

let test_multiple_immutable_borrows_succeed () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Let
          {
            sym = "a";
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
            is_mutable = false;
          };
        Let
          {
            sym = "b";
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
            is_mutable = false;
          };
      ]
  in
  let expected = Ok () in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "multiple immut borrows succeed" expected result

let test_mut_borrow_then_immut_in_separate_blocks_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 42); is_mutable = false };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "b";
                   expr = BorrowExpr { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                 };
             ]);
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
          };
      ]
  in
  let expected = Ok () in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "mut borrow then immut in separate blocks succeeds" expected result

let test_move_after_mut_borrow_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "val"; expr = Literal (Int 9); is_mutable = false };
        Let
          {
            sym = "x";
            expr = BorrowExpr { is_mutable = true; expr = Nam "val" };
            is_mutable = false;
          };
        Let { sym = "copy"; expr = Nam "val"; is_mutable = false };
      ]
  in
  let expected = Error (make_move_err_msg "val" MutablyBorrowed) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "move after mut borrow fails" expected result

let test_borrow_after_move_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let { sym = "x"; expr = Literal (Int 1); is_mutable = false };
        Let { sym = "y"; expr = Nam "x"; is_mutable = false };
        (* move *)
        Let
          {
            sym = "a";
            expr = BorrowExpr { is_mutable = false; expr = Nam "x" };
            is_mutable = false;
          };
        (* illegal *)
      ]
  in
  let expected = Error (make_borrow_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "borrow after move fails" expected result

let () =
  let open Alcotest in
  run "Ownership Checker Tests"
    [
      ( "Ownership rules",
        [
          test_case "simple let assmt borrow succeeds" `Quick
            test_simple_let_assmt_borrow_succeeds;
          test_case "simple fun arg borrow succeeds" `Quick
            test_simple_fun_arg_borrow_succeeds;
          test_case "simple fun arg move succeeds" `Quick
            test_simple_fun_arg_move_succeeds;
          test_case "use after fun arg move fails" `Quick
            test_use_after_fun_arg_move_fails;
          test_case "multiple mutable borrows fail" `Quick
            test_multiple_mutable_borrows_fail;
          test_case "mut and immut borrow fails" `Quick
            test_mutable_and_immutable_borrow_fails;
          test_case "mut and immut in separate blocks succeed" `Quick
            test_mutable_and_immutable_in_diff_scopes_succeed;
          test_case "nested mut and immut fails" `Quick
            test_nested_mutable_and_immutable_borrow_fails;
          test_case "nested multiple immut borrows succeed" `Quick
            test_nested_multiple_immutable_borrows_succeed;
          test_case "use after move fails" `Quick test_use_after_move_fails;
          test_case "multiple immut borrows succeed" `Quick
            test_multiple_immutable_borrows_succeed;
          test_case "borrow after move fails" `Quick
            test_borrow_after_move_fails;
          test_case "mut then immut borrow in blocks succeeds" `Quick
            test_mut_borrow_then_immut_in_separate_blocks_succeeds;
          test_case "move after mut borrow fails" `Quick
            test_move_after_mut_borrow_fails;
        ] );
    ]
