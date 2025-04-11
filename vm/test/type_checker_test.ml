open Vm.Type_checker

let test_literal_mismatch_fails () =
  let tc = create () in
  let node =
    Vm.Ast.Let
      {
        sym = "x";
        declared_type = TBoolean;
        expr = Literal (Int 1);
        is_mutable = false;
      }
  in
  let result = check_type node tc in
  let expected = Error (make_type_err_msg TBoolean TInt) in

  Alcotest.(check (result unit string)) "test" expected result

let test_match_int_succeeds () =
  let tc = create () in
  let node =
    Vm.Ast.Let
      {
        sym = "x";
        declared_type = TInt;
        expr = Literal (Int 1);
        is_mutable = false;
      }
  in
  let actual = check_type node tc in
  let expected = Ok () in
  Alcotest.(check (result unit string)) "test" expected actual

let test_fun_succeeds () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Fun
         {
           sym = "f";
           prms = [ "a" ];
           declared_type = TFunction { ret = TInt; prms = [ TInt ] };
           body = Ret { expr = Literal (Int 1); prms = [ "a" ] };
         })
  in
  let actual = check_type node tc in
  let expected = Ok () in
  Alcotest.(check (result unit string)) "test" expected actual

let test_fun_fails () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Fun
         {
           sym = "f";
           prms = [ "a" ];
           declared_type = TFunction { ret = TUndefined; prms = [ TInt ] };
           body = Ret { expr = Literal (Int 1); prms = [ "a" ] };
         })
  in
  let actual = check_type node tc in
  let expected = Error "Return type mismatch" in
  Alcotest.(check (result unit string)) "test" expected actual

let test_fun_compatible_prms_args_succeeds () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Sequence
         [
           Fun
             {
               sym = "f";
               prms = [ "a" ];
               declared_type = TFunction { ret = TInt; prms = [ TInt ] };
               body = Ret { expr = Literal (Int 1); prms = [ "a" ] };
             };
           App { fun_nam = Nam "f"; args = [ Literal (Int 1) ] };
         ])
  in
  let actual = check_type node tc in
  let expected = Ok () in
  Alcotest.(check (result unit string)) "test" expected actual

let test_fun_uncompatible_prms_args_fails () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Sequence
         [
           Fun
             {  
               sym = "f";
               prms = [ "a" ];
               declared_type = TFunction { ret = TInt; prms = [ TInt ] };
               body = Ret { expr = Literal (Int 1); prms = [ "a" ] };
             };
           App { fun_nam = Nam "f"; args = [ Literal (Boolean true) ] };
         ])
  in
  let actual = check_type node tc in
  let expected = Error "Argument type mismatch" in
  Alcotest.(check (result unit string)) "test" expected actual

let test_binop_mismatched_operands_fails () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Sequence
         [
           Binop
             {
               sym = "+";
               frst = Literal (Int 1);
               scnd = Literal (Boolean false);
             };
         ])
  in
  let actual = check_type node tc in
  let expected = Error "Binary operands have incompatible types" in
  Alcotest.(check (result unit string)) "test" expected actual

let test_binop_matching_operands_succeeds () =
  let tc = create () in
  let open Vm.Ast in
  let node =
    Block
      (Sequence
         [ Binop { sym = "+"; frst = Literal (Int 1); scnd = Literal (Int 5) } ])
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
          test_case "Literal int" `Quick test_match_int_succeeds;
          test_case "Function that returns int" `Quick test_fun_succeeds;
          test_case "Function that returns when shouldnt'" `Quick test_fun_fails;
          test_case "Binop mismatched operands" `Quick
            test_binop_mismatched_operands_fails;
          test_case "Binop matching operands" `Quick
            test_binop_matching_operands_succeeds;
          test_case "compatible prms args fun" `Quick
            test_fun_compatible_prms_args_succeeds;
          test_case "uncompatible prms args" `Quick
            test_fun_uncompatible_prms_args_fails;
        ] );
    ]
