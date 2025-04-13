open Vm.Compiler
open Vm.Value

(* Pretty-printer & equality for compiled_instruction *)



(* New testable type for indexed instructions *)
let pp_indexed_instr fmt (i, instr) =
  Format.fprintf fmt "%d: %s" i (string_of_instruction instr)

let testable_indexed_instr = Alcotest.testable pp_indexed_instr ( = )

let check_instr_list msg expected actual =
  let expected_with_indices = List.mapi (fun i instr -> (i, instr)) expected in
  let actual_with_indices = List.mapi (fun i instr -> (i, instr)) actual in
  Alcotest.(check (list testable_indexed_instr)) msg expected_with_indices actual_with_indices

(* ---------- Test cases ---------- *)

let test_simple_borrow_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "simple borrow lifetime" expected result

let test_borrow_after_use_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "borrow after use lifetime" expected result

let test_nested_borrow_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "blk",
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "let",
                  "sym": "y",
                  "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
                  "is_mutable": false,
                  "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
                }
              ]
            }
          } 
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      ENTER_SCOPE { num = 1 };
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested borrow lifetime" expected result

let test_function_no_return_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "blk",
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "let",
                  "sym": "y",
                  "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
                  "is_mutable": false,
                  "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
                },
                {
                  "tag": "let",
                  "sym": "z",
                  "expr": { "tag": "lit", "val": 4 },
                  "is_mutable": false,
                  "declared_type": { "kind": "basic", "value": "int" }
                }
              ]
            }
          },
          {
            "tag": "assmt",
            "sym": "x",
            "expr": { "tag": "lit", "val": 3 }
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      ENTER_SCOPE { num = 2 };
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      POP;
      LDC (Int 4);
      ASSIGN { frame_index = 1; value_index = 1 };
      FREE { pos = { frame_index = 1; value_index = 1 }; to_free = true };
      EXIT_SCOPE;
      POP;
      LDC (Int 3);
      ASSIGN { frame_index = 0; value_index = 0 };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function with no return lifetime" expected result

let test_nested_borrow_through_ref_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "blk",
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "let",
                  "sym": "z",
                  "expr": { "tag": "nam", "sym": "y" },
                  "is_mutable": false,
                  "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
                }
              ]
            }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = false };
      POP;
      ENTER_SCOPE { num = 1 };
      LD { sym = "y"; pos = { frame_index = 0; value_index = 1 } };
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested borrow through ref lifetime" expected result

let test_nested_borrow_with_owned_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "blk",
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "let",
                  "sym": "z",
                  "expr": { "tag": "lit", "val": 0 },
                  "is_mutable": false,
                  "declared_type": { "kind": "basic", "value": "int" }
                }
              ]
            }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      POP;
      ENTER_SCOPE { num = 1 };
      LDC (Int 0);
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested borrow with owned lifetime" expected result

let test_complex_nested_borrow_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 4 },
            "is_mutable": true,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "j",
            "expr": { "tag": "lit", "val": 5 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": true,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "blk",
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "let",
                  "sym": "z",
                  "expr": { "tag": "lit", "val": 3 },
                  "is_mutable": true,
                  "declared_type": { "kind": "basic", "value": "int" }
                },
                {
                  "tag": "let",
                  "sym": "l",
                  "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "z" } },
                  "is_mutable": false,
                  "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
                },
                {
                  "tag": "assmt",
                  "sym": "z",
                  "expr": { "tag": "lit", "val": 4 }
                }
              ]
            }
          },
          {
            "tag": "assmt",
            "sym": "x",
            "expr": { "tag": "lit", "val": 3 }
          },
          {
            "tag": "assmt",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "j" } }
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 3 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LDC (Int 5);
      ASSIGN { frame_index = 0; value_index = 1 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 2 };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = false };
      POP;
      ENTER_SCOPE { num = 2 };
      LDC (Int 3);
      ASSIGN { frame_index = 1; value_index = 0 };
      POP;
      LD { sym = "z"; pos = { frame_index = 1; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 1; value_index = 1 };
      FREE { pos = { frame_index = 1; value_index = 1 }; to_free = true };
      POP;
      LDC (Int 4);
      ASSIGN { frame_index = 1; value_index = 0 };
      FREE { pos = { frame_index = 1; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      POP;
      LDC (Int 3);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "j"; pos = { frame_index = 0; value_index = 1 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 2 };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true }; 
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "complex nested borrow lifetime" expected result

let test_borrow_in_binop_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 0 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "let",
            "sym": "k",
            "expr": { 
              "tag": "binop", 
              "sym": "+", 
              "frst": { "tag": "nam", "sym": "y" },
              "scnd": { "tag": "lit", "val": 3 }
            },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 3 };
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = false };
      POP;
      LD { sym = "y"; pos = { frame_index = 0; value_index = 1 } };
      LDC (Int 3);
      BINOP { sym = "+" };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      ASSIGN { frame_index = 0; value_index = 2 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "borrow in binop lifetime" expected result



  (* let x = 0 
let y = &x
let k = y + 3
let m = x +2;
let l = y + 4
x; *)
let test_multiple_borrow_uses_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 0 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "let",
            "sym": "k",
            "expr": { 
              "tag": "binop", 
              "sym": "+", 
              "frst": { "tag": "nam", "sym": "y" },
              "scnd": { "tag": "lit", "val": 3 }
            },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "m",
            "expr": { 
              "tag": "binop", 
              "sym": "+", 
              "frst": { "tag": "nam", "sym": "x" },
              "scnd": { "tag": "lit", "val": 2 }
            },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "testvariable",
            "expr": { 
              "tag": "binop", 
              "sym": "+", 
              "frst": { "tag": "nam", "sym": "y" },
              "scnd": { "tag": "lit", "val": 4 }
            },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 5 };
      LDC (Int 0);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = false };
      POP;
      LD { sym = "y"; pos = { frame_index = 0; value_index = 1 } };
      LDC (Int 3);
      BINOP { sym = "+" };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = false };
      ASSIGN { frame_index = 0; value_index = 2 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      LDC (Int 2);
      BINOP { sym = "+" };
      ASSIGN { frame_index = 0; value_index = 3 };
      POP;
      LD { sym = "y"; pos = { frame_index = 0; value_index = 1 } };
      LDC (Int 4);
      BINOP { sym = "+" };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      ASSIGN { frame_index = 0; value_index = 4 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 3 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 4 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "multiple borrow uses lifetime" expected result

let test_unop_borrow_lifetime () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "let",
            "sym": "x",
            "expr": { "tag": "lit", "val": 5 },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          {
            "tag": "let",
            "sym": "y",
            "expr": { "tag": "borrow", "mutable": false, "expr": { "tag": "nam", "sym": "x" } },
            "is_mutable": false,
            "declared_type": { "kind": "ref", "is_mutable": false, "value": "int" }
          },
          {
            "tag": "let",
            "sym": "k",
            "expr": { 
              "tag": "unop", 
              "sym": "-", 
              "frst": { "tag": "nam", "sym": "y" }
            },
            "is_mutable": false,
            "declared_type": { "kind": "basic", "value": "int" }
          },
          { "tag": "nam", "sym": "x" }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 3 };
      LDC (Int 5);
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      BORROW false;
      ASSIGN { frame_index = 0; value_index = 1 };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = false };
      POP;
      LD { sym = "y"; pos = { frame_index = 0; value_index = 1 } };
      UNOP { sym = "-" };
      FREE { pos = { frame_index = 0; value_index = 1 }; to_free = true };
      ASSIGN { frame_index = 0; value_index = 2 };
      POP;
      LD { sym = "x"; pos = { frame_index = 0; value_index = 0 } };
      FREE { pos = { frame_index = 0; value_index = 0 }; to_free = true };
      FREE { pos = { frame_index = 0; value_index = 2 }; to_free = true };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "unop borrow lifetime" expected result

let () =
  let open Alcotest in
  run "Lifetime Tests"
    [
      ( "Lifetime rules",
        [
          test_case "test_simple_borrow_lifetime" `Quick test_simple_borrow_lifetime;
          test_case "test_borrow_after_use_lifetime" `Quick test_borrow_after_use_lifetime;
          test_case "test_nested_borrow_lifetime" `Quick test_nested_borrow_lifetime;
          test_case "test_function_no_return_lifetime" `Quick test_function_no_return_lifetime;
          test_case "test_nested_borrow_through_ref_lifetime" `Quick test_nested_borrow_through_ref_lifetime;
          test_case "test_nested_borrow_with_owned_lifetime" `Quick test_nested_borrow_with_owned_lifetime;
          test_case "test_complex_nested_borrow_lifetime" `Quick test_complex_nested_borrow_lifetime;
          test_case "test_borrow_in_binop_lifetime" `Quick test_borrow_in_binop_lifetime;
          test_case "test_multiple_borrow_uses_lifetime" `Quick test_multiple_borrow_uses_lifetime;
          test_case "test_unop_borrow_lifetime" `Quick test_unop_borrow_lifetime;
        ] );
    ]
