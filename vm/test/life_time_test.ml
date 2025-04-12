open Vm.Compiler
open Vm.Value

(* Pretty-printer & equality for compiled_instruction *)
let pp_instr fmt instr =
  Format.pp_print_string fmt (string_of_instruction instr)

let testable_instr = Alcotest.testable pp_instr ( = )

let check_instr_list msg expected actual =
  Alcotest.(check (list testable_instr)) msg expected actual

(* ---------- Test cases ---------- *)

let test_simple_let_sequence_lifetime () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "seq",
        "stmts":
        [ {"tag": "let", "sym": "y", "expr": {"tag": "lit", "val": 4}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
          {"tag": "let", "sym": "x", "expr": {"tag": "lit", "val": 2}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
          {"tag": "let", "sym": "z", "expr": {"tag": "lit", "val": 0}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}}]}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 3 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      POP;
      LDC (Int 2);
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 2 };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "simple let sequence lifetime" expected result

let test_assignment_lifetime () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "seq",
        "stmts":
        [ {"tag": "let", "sym": "y", "expr": {"tag": "lit", "val": 4}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
          {"tag": "let", "sym": "x", "expr": {"tag": "lit", "val": 2}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
          {"tag": "assmt", "sym": "y", "expr": {"tag": "lit", "val": 1}}]}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = false };
      POP;
      LDC (Int 2);
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      POP;
      LDC (Int 1);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "assignment lifetime" expected result

let test_nested_block_lifetime () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "seq",
        "stmts":
        [{"tag": "let", "sym": "y", "expr": {"tag": "lit", "val": 4}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
         {"tag": "blk", 
          "body": {"tag": "seq", 
                  "stmts": [
                    {"tag": "let", "sym": "x", "expr": {"tag": "binop", "sym": "+", "frst": {"tag": "nam", "sym": "y"}, "scnd": {"tag": "lit", "val": 7}}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
                    {"tag": "binop", "sym": "*", "frst": {"tag": "nam", "sym": "x"}, "scnd": {"tag": "lit", "val": 2}}
                  ]}},
         {"tag": "let", "sym": "z", "expr": {"tag": "lit", "val": 0}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}}]}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = false };
      POP;
      ENTER_SCOPE { num = 1 };
      LD { sym = "y"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      LDC (Int 7);
      BINOP { sym = "+" };
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = false };
      POP;
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      LDC (Int 2);
      BINOP { sym = "*" };
      EXIT_SCOPE;
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested block lifetime" expected result

let test_nested_block_multiple_uses () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "seq",
        "stmts":
        [{"tag": "let", "sym": "y", "expr": {"tag": "lit", "val": 4}, "is_mutable": true, "declared_type": {"kind": "basic", "value": "int"}},
         {"tag": "blk", 
          "body": {"tag": "seq", 
                  "stmts": [
                    {"tag": "let", "sym": "x", "expr": {"tag": "binop", "sym": "+", "frst": {"tag": "nam", "sym": "y"}, "scnd": {"tag": "lit", "val": 7}}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
                    {"tag": "assmt", "sym": "y", "expr": {"tag": "lit", "val": 0}}
                  ]}},
         {"tag": "assmt", "sym": "y", "expr": {"tag": "lit", "val": 0}}]}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = false };
      POP;
      ENTER_SCOPE { num = 1 };
      LD { sym = "y"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = false };
      LDC (Int 7);
      BINOP { sym = "+" };
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = false };
      EXIT_SCOPE;
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested block with multiple uses" expected result

let test_function_lifetime () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "fun",
        "sym": "f",
        "prms": [{"name": "x"}],
        "declared_type": {
          "kind": "function",
          "ret": "int",
          "prms": ["int"]
        },
        "body":
        { "tag": "blk",
          "body":
          { "tag": "seq",
            "stmts":
            [ {"tag": "const", "sym": "y", "expr": {"tag": "lit", "val": 0}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
              {"tag": "assmt", "sym": "x", "expr": {"tag": "lit", "val": 0}},
              {"tag": "let", "sym": "k", "expr": {"tag": "lit", "val": 1}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
              {"tag": "ret", "expr": {"tag": "lit", "val": 1}}]}}}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 1; addr = 3 };
      GOTO 23;
      ENTER_SCOPE { num = 2 };
      LDC (Int 0);
      ASSIGN { frame_index = 2; value_index = 0 };
      FREE { pos = { frame_index = 2; value_index = 0 }; to_free = true };
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = false };
      POP;
      LDC (Int 1);
      ASSIGN { frame_index = 2; value_index = 1 };
      FREE { pos = { frame_index = 2; value_index = 1 }; to_free = true };
      POP;
      LDC (Int 1);
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      RESET;
      EXIT_SCOPE;
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function lifetime" expected result

let test_function_no_return_lifetime () =
  let json_str =
    {|
    { "tag": "blk",
      "body":
      { "tag": "fun",
        "sym": "f",
        "prms": [{"name": "x"}],
        "declared_type": {
          "kind": "function",
          "ret": "int",
          "prms": ["int"]
        },
        "body":
        { "tag": "blk",
          "body":
          { "tag": "seq",
            "stmts":
            [ {"tag": "const", "sym": "y", "expr": {"tag": "lit", "val": 0}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}},
              {"tag": "assmt", "sym": "x", "expr": {"tag": "lit", "val": 0}},
              {"tag": "let", "sym": "k", "expr": {"tag": "lit", "val": 1}, "is_mutable": false, "declared_type": {"kind": "basic", "value": "int"}}]}}}}
  |}
  in
  let result = compile_program json_str in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 1; addr = 3 };
      GOTO 19;
      ENTER_SCOPE { num = 2 };
      LDC (Int 0);
      ASSIGN { frame_index = 2; value_index = 0 };
      FREE { pos = { frame_index = 2; value_index = 0 }; to_free = true };
      POP;
      LDC (Int 0);
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = false };
      POP;
      LDC (Int 1);
      ASSIGN { frame_index = 2; value_index = 1 };
      FREE { pos = { frame_index = 2; value_index = 1 }; to_free = true };
      EXIT_SCOPE;
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function no return lifetime" expected result

let () =
  let open Alcotest in
  run "Lifetime Tests"
    [
      ( "Variable Lifetime",
        [
          test_case "test_simple_let_sequence_lifetime" `Quick
            test_simple_let_sequence_lifetime;
          test_case "test_assignment_lifetime" `Quick test_assignment_lifetime;
          test_case "test_nested_block_lifetime" `Quick
            test_nested_block_lifetime;
          test_case "test_nested_block_multiple_uses" `Quick
            test_nested_block_multiple_uses;
          test_case "test_function_lifetime" `Quick test_function_lifetime;
          test_case "test_function_no_return_lifetime" `Quick
            test_function_no_return_lifetime;
        ] );
    ]
