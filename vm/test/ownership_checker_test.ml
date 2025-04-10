open Vm.Ownership_checker

let test_simple_let_assmt_borrow_succeeds () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            declared_type = TRef { is_mutable = false; base = TInt };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Fun
          {
            sym = "f";
            body = Ret (Literal (Int 1));
            prms = [ "a" ];
            declared_type = TFunction { ret = TInt; prms = [ TInt ] };
          };
        App
          {
            fun_nam = Nam "f";
            args = [ Borrow { expr = Nam "x"; is_mutable = false } ];
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Fun
          {
            sym = "f";
            body = Ret (Literal (Int 1));
            prms = [ "a" ];
            declared_type = TFunction { ret = TInt; prms = [ TInt ] };
          };
        App { fun_nam = Nam "f"; args = [ Nam "x" ] };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Fun
          {
            sym = "f";
            body = Ret (Literal (Int 1));
            prms = [ "a" ];
            declared_type = TFunction { ret = TInt; prms = [ TInt ] };
          };
        App { fun_nam = Nam "f"; args = [ Nam "x" ] };
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
        Let
          {
            sym = "x";
            expr = Literal (String "hello");
            is_mutable = false;
            declared_type = TString;
          };
        Let
          {
            sym = "a";
            expr = Borrow { is_mutable = true; expr = Nam "x" };
            is_mutable = false;
            declared_type = TRef { is_mutable = true; base = TString };
          };
        Let
          {
            sym = "b";
            expr = Borrow { is_mutable = true; expr = Nam "x" };
            is_mutable = false;
            declared_type = TRef { is_mutable = true; base = TString };
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
        Let
          {
            sym = "x";
            expr = Literal (String "hello");
            is_mutable = false;
            declared_type = TString;
          };
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = Borrow { is_mutable = true; expr = Nam "x" };
            declared_type = TString;
          };
        Let
          {
            sym = "b";
            is_mutable = false;
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            declared_type = TRef { is_mutable = false; base = TString };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "y";
                   expr = Borrow { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                   declared_type = TRef { is_mutable = true; base = TInt };
                 };
             ]);
        Block
          (Sequence
             [
               Let
                 {
                   sym = "z";
                   expr = Borrow { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                   declared_type = TRef { is_mutable = true; base = TInt };
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
        Let
          {
            sym = "x";
            expr = Literal (String "hello");
            is_mutable = false;
            declared_type = TString;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "a";
                   is_mutable = false;
                   expr = Borrow { is_mutable = true; expr = Nam "x" };
                   declared_type = TRef { is_mutable = true; base = TString };
                 };
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "b";
                          is_mutable = false;
                          expr = Borrow { is_mutable = true; expr = Nam "x" };
                          declared_type =
                            TRef { is_mutable = true; base = TString };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "a";
                   is_mutable = false;
                   expr = Borrow { is_mutable = false; expr = Nam "x" };
                   declared_type = TRef { is_mutable = false; base = TInt };
                 };
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "b";
                          is_mutable = false;
                          expr = Borrow { is_mutable = false; expr = Nam "x" };
                          declared_type =
                            TRef { is_mutable = false; base = TInt };
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
           Let
             {
               sym = "x";
               expr = Literal (Int 1);
               is_mutable = false;
               declared_type = TInt;
             };
           Let
             {
               sym = "y";
               expr = Nam "x";
               is_mutable = false;
               declared_type = TRef { is_mutable = false; base = TInt };
             };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Let
          {
            sym = "a";
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            declared_type = TRef { is_mutable = false; base = TInt };
            is_mutable = false;
          };
        Let
          {
            sym = "b";
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            is_mutable = false;
            declared_type = TRef { is_mutable = false; base = TInt };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 42);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "b";
                   expr = Borrow { is_mutable = true; expr = Nam "x" };
                   is_mutable = false;
                   declared_type = TRef { is_mutable = true; base = TInt };
                 };
             ]);
        Let
          {
            sym = "a";
            is_mutable = false;
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            declared_type = TRef { is_mutable = false; base = TInt };
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
        Let
          {
            sym = "val";
            expr = Literal (String "hello");
            is_mutable = false;
            declared_type = TString;
          };
        Let
          {
            sym = "x";
            expr = Borrow { is_mutable = true; expr = Nam "val" };
            is_mutable = false;
            declared_type = TRef { is_mutable = true; base = TString };
          };
        Let
          {
            sym = "copy";
            expr = Nam "val";
            is_mutable = false;
            declared_type = TRef { is_mutable = false; base = TString };
          };
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
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Let
          {
            sym = "y";
            expr = Nam "x";
            is_mutable = false;
            declared_type = TRef { is_mutable = false; base = TInt };
          };
        (* move *)
        Let
          {
            sym = "a";
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            is_mutable = false;
            declared_type = TRef { is_mutable = false; base = TInt };
          };
        (* illegal *)
      ]
  in
  let expected = Error (make_borrow_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "borrow after move fails" expected result

let test_borrow_after_move_in_different_scopes_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "y";
                   expr = Nam "x";
                   is_mutable = false;
                   declared_type = TRef { is_mutable = false; base = TInt };
                 };
               (* Move x to y *)
             ]);
        Let
          {
            sym = "z";
            expr = Borrow { is_mutable = false; expr = Nam "x" };
            (* Illegal borrow of moved value *)
            is_mutable = false;
            declared_type = TRef { is_mutable = false; base = TInt };
          };
      ]
  in
  let expected = Error (make_borrow_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "borrow after move in different scopes fails" expected result

let test_move_and_borrow_same_var_in_nested_blocks_fails () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "y";
                   expr = Nam "x";
                   is_mutable = false;
                   declared_type = TRef { is_mutable = false; base = TInt };
                 };
               (* Move x to y *)
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "z";
                          expr = Borrow { is_mutable = false; expr = Nam "x" };
                          (* Borrow x in nested block after it was moved *)
                          is_mutable = false;
                          declared_type =
                            TRef { is_mutable = false; base = TInt };
                        };
                    ]);
             ]);
      ]
  in
  let expected = Error (make_borrow_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "move and borrow same var in nested blocks fails" expected result

let test_complex_ownership_with_nested_blocks () =
  let checker = create () in
  let open Vm.Ast in
  let node =
    Sequence
      [
        Let
          {
            sym = "x";
            expr = Literal (Int 1);
            is_mutable = false;
            declared_type = TInt;
          };
        Block
          (Sequence
             [
               Let
                 {
                   sym = "y";
                   expr = Nam "x";
                   is_mutable = false;
                   declared_type = TRef { is_mutable = false; base = TInt };
                 };
               (* Move x to y *)
               Block
                 (Sequence
                    [
                      Let
                        {
                          sym = "a";
                          expr = Borrow { is_mutable = false; expr = Nam "x" };
                          (* Attempting to borrow moved value in nested block *)
                          is_mutable = false;
                          declared_type =
                            TRef { is_mutable = false; base = TInt };
                        };
                    ]);
             ]);
      ]
  in
  let expected = Error (make_borrow_err_msg "x" Moved) in
  let result = check_ownership node checker in
  Alcotest.(check (result unit string))
    "complex ownership with nested blocks fails" expected result

let () =
  let open Alcotest in
  run "Ownership Checker Tests"
    [
      ( "Ownership rules",
        [
          test_case "test_simple_let_assmt_borrow_succeeds" `Quick
            test_simple_let_assmt_borrow_succeeds;
          test_case "test_simple_fun_arg_borrow_succeeds" `Quick
            test_simple_fun_arg_borrow_succeeds;
          test_case "test_simple_fun_arg_move_succeeds" `Quick
            test_simple_fun_arg_move_succeeds;
          test_case "test_use_after_fun_arg_move_fails" `Quick
            test_use_after_fun_arg_move_fails;
          test_case "test_multiple_mutable_borrows_fail" `Quick
            test_multiple_mutable_borrows_fail;
          test_case "test_mutable_and_immutable_borrow_fails" `Quick
            test_mutable_and_immutable_borrow_fails;
          test_case "test_mutable_and_immutable_in_diff_scopes_succeed" `Quick
            test_mutable_and_immutable_in_diff_scopes_succeed;
          test_case "test_nested_mutable_and_immutable_borrow_fails" `Quick
            test_nested_mutable_and_immutable_borrow_fails;
          test_case "test_nested_multiple_immutable_borrows_succeed" `Quick
            test_nested_multiple_immutable_borrows_succeed;
          test_case "test_use_after_move_fails" `Quick test_use_after_move_fails;
          test_case "test_multiple_immutable_borrows_succeed" `Quick
            test_multiple_immutable_borrows_succeed;
          test_case "test_borrow_after_move_fails" `Quick
            test_borrow_after_move_fails;
          test_case "test_mut_borrow_then_immut_in_separate_blocks_succeeds"
            `Quick test_mut_borrow_then_immut_in_separate_blocks_succeeds;
          test_case "test_move_after_mut_borrow_fails" `Quick
            test_move_after_mut_borrow_fails;
          test_case "test_borrow_after_move_in_different_scopes_fails" `Quick
            test_borrow_after_move_in_different_scopes_fails;
          test_case "test_move_and_borrow_same_var_in_nested_blocks_fails"
            `Quick test_move_and_borrow_same_var_in_nested_blocks_fails;
          test_case "test_complex_ownership_with_nested_blocks" `Quick
            test_complex_ownership_with_nested_blocks;
        ] );
    ]
