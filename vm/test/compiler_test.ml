open Vm.Compiler

(* Pretty-printer & equality for compiled_instruction *)
let pp_instr fmt instr =
  Format.pp_print_string fmt (string_of_instruction instr)

let testable_instr = Alcotest.testable pp_instr ( = )

let check_instr_list msg expected actual =
  Alcotest.(check (list testable_instr)) msg expected actual

(* ---------- Test cases ---------- *)

let test_literal_int () =
  let json = {|{ "tag": "lit", "val": 42 }|} in
  let result = compile_program json in
  let expected = [ LDC (Int 42); DONE ] in
  check_instr_list "literal int" expected result

let test_literal_string () =
  let json = {|{ "tag": "lit", "val": "hello" }|} in
  let result = compile_program json in
  let expected = [ LDC (String "hello"); DONE ] in
  check_instr_list "literal string" expected result

let test_binop_add () =
  let json =
    {|{
    "tag": "binop",
    "sym": "+",
    "frst": { "tag": "lit", "val": 1 },
    "scnd": { "tag": "lit", "val": 2 }
  }|}
  in
  let result = compile_program json in
  let expected = [ LDC (Int 1); LDC (Int 2); BINOP { sym = "+" }; DONE ] in
  check_instr_list "binary op + " expected result

let test_seq_two_exprs () =
  let json =
    {|{
    "tag": "seq",
    "stmts": [
      { "tag": "lit", "val": 1 },
      { "tag": "lit", "val": 2 }
    ]
  }|}
  in
  let result = compile_program json in
  let expected = [ LDC (Int 1); POP; LDC (Int 2); DONE ] in
  check_instr_list "sequence of two expressions" expected result

let test_blk_with_let () =
  let json =
    {|{
    "tag": "blk",
    "body": {
      "tag": "seq",
      "stmts": [
        { "tag": "let", "sym": "x", "expr": { "tag": "lit", "val": 4 } }
      ]
    }
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN {frame_index = 0; value_index = 0};
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "block with let x" expected result

let test_ld_variable () =
  let json =
    {|{"tag": "blk", "body": {"tag": "seq", "stmts": [{"tag": "let", "sym": "x", "expr": {"tag": "lit", "val": 4}}, {"tag": "nam", "sym": "x"}]}}|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN {frame_index = 0; value_index = 0};
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "load variable x" expected result

let test_unary_minus () =
  let json =
    {|{"tag": "blk", "body": {"tag": "unop", "sym": "-unary", "frst": {"tag": "lit", "val": 3}}}|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 0 };
      LDC (Int 3);
      UNOP { sym = "-unary" };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "unary minus operation" expected result

let test_unary_not () =
  let json =
    {|{"tag": "blk", "body": {"tag": "unop", "sym": "!", "frst": {"tag": "lit", "val": true}}}|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 0 };
      LDC (Boolean true);
      UNOP { sym = "!" };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "unary not operation" expected result

let test_function_no_params () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "fun",
        "sym": "f",
        "prms": [],
        "body": {
          "tag": "seq",
          "stmts": [{
            "tag": "ret",
            "expr": {
              "tag": "lit",
              "val": 1
            }
          }]
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 7;
      LDC (Int 1);
      RESET;
      LDC Undefined;
      RESET;
      ASSIGN {frame_index = 1; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function declaration with no parameters" expected result

let test_function_with_params () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "fun",
        "sym": "f",
        "prms": [
          {
            "name": "x",
            "paramType": { "type": "i32" }
          },
          {
            "name": "y",
            "paramType": { "type": "i32" }
          }
        ],
        "retType": "i32",
        "body": {
          "tag": "seq",
          "stmts": [{
            "tag": "ret",
            "expr": {
              "tag": "lit",
              "val": 1
            }
          }]
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 2; addr = 3 };
      GOTO 7;
      LDC (Int 1);
      RESET;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function declaration with parameters and types" expected
    result

let test_function_with_binop () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "fun",
        "sym": "f",
        "prms": [
          { "name": "x", "paramType": { "type": "i32" } },
          { "name": "y", "paramType": { "type": "i32" } }
        ],
        "retType": "i32",
        "body": {
          "tag": "seq",
          "stmts": [{
            "tag": "ret",
            "expr": {
              "tag": "binop",
              "sym": "+",
              "frst": { "tag": "nam", "sym": "x" },
              "scnd": { "tag": "nam", "sym": "y" }
            }
          }]
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 2; addr = 3 };
      GOTO 9;
      LD { sym = "x"; pos = { frame_index = 2; value_index = 0 } };
      LD { sym = "y"; pos = { frame_index = 2; value_index = 1 } };
      BINOP { sym = "+" };
      RESET;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function with binop parameters" expected result

let test_function_with_block_and_const () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "fun",
        "sym": "f",
        "prms": [
          {
            "name": "x",
            "paramType": { "type": "i32" }
          },
          {
            "name": "y",
            "paramType": { "type": "i32" }
          }
        ],
        "retType": "i32",
        "body": {
          "tag": "blk",
          "body": {
            "tag": "seq",
            "stmts": [
              {
                "tag": "const",
                "sym": "z",
                "expr": {
                  "tag": "lit",
                  "val": 0
                }
              },
              {
                "tag": "ret",
                "expr": {
                  "tag": "binop",
                  "sym": "+",
                  "frst": { "tag": "nam", "sym": "x" },
                  "scnd": { "tag": "nam", "sym": "y" }
                }
              }
            ]
          }
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 2; addr = 3 };
      GOTO 14;
      ENTER_SCOPE { num = 1 };
      LDC (Int 0);
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 2; value_index = 0 } };
      LD { sym = "y"; pos = { frame_index = 2; value_index = 1 } };
      BINOP { sym = "+" };
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function with block and const" expected result

(* ---------- Run tests ---------- *)

let () =
  let open Alcotest in
  run "Compiler Tests"
    [
      ( "compiler",
        [
          test_case "Literal int" `Quick test_literal_int;
          test_case "Literal string" `Quick test_literal_string;
          test_case "Binop +" `Quick test_binop_add;
          test_case "Sequence of two expressions" `Quick test_seq_two_exprs;
          test_case "Block with let" `Quick test_blk_with_let;
          test_case "Load variable" `Quick test_ld_variable;
          test_case "Unary minus" `Quick test_unary_minus;
          test_case "Unary not" `Quick test_unary_not;
          test_case "Function with no parameters" `Quick test_function_no_params;
          test_case "Function with parameters and types" `Quick
            test_function_with_params;
          test_case "function with binop parameters" `Quick test_function_with_binop;
          test_case "function with block and const" `Quick test_function_with_block_and_const;
        ] );
    ]
