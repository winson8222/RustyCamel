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
        { "tag": "let", "sym": "x" }
      ]
    }
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      ASSIGN { pos = { frame_index = 0; value_index = 0 } };
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
      ASSIGN { pos = { frame_index = 0; value_index = 0 } };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "load variable x" expected result

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
        ] );
    ]
