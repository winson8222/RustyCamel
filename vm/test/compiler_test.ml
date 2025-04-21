open Vm.Compiler

(* Pretty-printer & equality for compiled_instruction *)
let pp_instr fmt instr =
  Format.pp_print_string fmt (string_of_instruction instr)

let testable_instr = Alcotest.testable pp_instr ( = )

let check_instr_list msg expected actual =
  Alcotest.(check (list testable_instr)) msg expected actual

(* ---------- Test cases ---------- *)


let test_factorial () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "factorial",
        "params": [
          {
            "type": "Param",
            "name": "n",
            "paramType": {
              "type": "BasicType",
              "name": "i32"
            },
            "isMutable": false
          }
        ],
        "returnType": {
          "type": "BasicType",
          "name": "i32"
        },
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "IfExpr",
              "condition": {
                "type": "BinaryExpr",
                "left": {
                  "type": "IdentExpr",
                  "name": "n"
                },
                "operator": "==",
                "right": {
                  "type": "Literal",
                  "value": 0
                }
              },
              "thenBranch": {
                "type": "Block",
                "statements": [
                  {
                    "type": "ReturnExpr",
                    "expr": {
                      "type": "Literal",
                      "value": 1
                    }
                  }
                ]
              },
              "elseBranch": {
                "type": "Block",
                "statements": [
                  {
                    "type": "ReturnExpr",
                    "expr": {
                      "type": "BinaryExpr",
                      "left": {
                        "type": "IdentExpr",
                        "name": "n"
                      },
                      "operator": "*",
                      "right": {
                        "type": "FunctionCall",
                        "name": "factorial",
                        "args": [
                          {
                            "type": "BinaryExpr",
                            "left": {
                              "type": "IdentExpr",
                              "name": "n"
                            },
                            "operator": "-",
                            "right": {
                              "type": "Literal",
                              "value": 1
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          ]
        }
      },
      {
        "type": "FunctionCall",
        "name": "factorial",
        "args": [
          {
            "type": "Literal",
            "value": 4
          }
        ]
      }
    ]
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 1; addr = 3 };
      GOTO 26;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 2; value_index = 0 } };
      LDC (Int 0);
      BINOP Equal;
      JOF 13;
      ENTER_SCOPE { num = 0 };
      LDC (Int 1);
      RESET;
      EXIT_SCOPE;
      GOTO 23;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 2; value_index = 0 } };
      LD { pos = { frame_index = 1; value_index = 0 } };
      LD { pos = { frame_index = 2; value_index = 0 } };
      LDC (Int 1);
      BINOP Subtract;
      CALL 1;
      BINOP Multiply;
      RESET;
      EXIT_SCOPE;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      POP;
      LD { pos = { frame_index = 1; value_index = 0 } };
      LDC (Int 4);
      CALL 1;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "factorial function with recursive call" expected result

let test_ownership_transfer () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "take_ownership",
        "params": [
          {
            "type": "Param",
            "name": "s",
            "paramType": {
              "type": "BasicType",
              "name": "String"
            },
            "isMutable": false
          }
        ],
        "returnType": {
          "type": "BasicType",
          "name": "String"
        },
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "ReturnExpr",
              "expr": {
                "type": "IdentExpr",
                "name": "s"
              }
            }
          ]
        }
      },
      {
        "type": "FnDecl",
        "name": "main",
        "params": [],
        "returnType": null,
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "LetDecl",
              "name": "s",
              "value": {
                "type": "Literal",
                "value": "hello"
              },
              "declaredType": {
                "type": "BasicType",
                "name": "String"
              },
              "isMutable": false
            },
            {
              "type": "LetDecl",
              "name": "x",
              "value": {
                "type": "FunctionCall",
                "name": "take_ownership",
                "args": [
                  {
                    "type": "IdentExpr",
                    "name": "s"
                  }
                ]
              },
              "declaredType": {
                "type": "BasicType",
                "name": "String"
              },
              "isMutable": false
            },
            {
              "type": "MacroCall",
              "name": "println",
              "args": [
                {
                  "type": "IdentExpr",
                  "name": "x"
                }
              ]
            }
          ]
        }
      }
    ]
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 2 };
      LDF { arity = 1; addr = 3 };
      GOTO 9;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 2; value_index = 0 } };
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      POP;
      LDF { arity = 0; addr = 13 };
      GOTO 30;
      ENTER_SCOPE { num = 2 };
      LDC (String "hello");
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      LD { pos = { frame_index = 1; value_index = 0 } };
      LD { pos = { frame_index = 3; value_index = 0 } };
      CALL 1;
      ASSIGN { frame_index = 3; value_index = 1 };
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      LD { pos = { frame_index = 3; value_index = 1 } };
      CALL 1;
      FREE { pos = { frame_index = 3; value_index = 1 }; to_free = true };
      FREE { pos = { frame_index = 3; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 1 };
      LD { pos = { frame_index = 1; value_index = 1 } };
      CALL 0;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "ownership transfer of string value" expected result

let test_while_loop_increment () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "main",
        "params": [],
        "returnType": null,
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "LetDecl",
              "name": "x",
              "value": {
                "type": "Literal",
                "value": 0
              },
              "declaredType": {
                "type": "BasicType",
                "name": "i32"
              },
              "isMutable": true
            },
            {
              "type": "WhileLoop",
              "condition": {
                "type": "BinaryExpr",
                "left": {
                  "type": "IdentExpr",
                  "name": "x"
                },
                "operator": "<",
                "right": {
                  "type": "Literal",
                  "value": 10
                }
              },
              "body": {
                "type": "Block",
                "statements": [
                  {
                    "type": "AssignmentStmt",
                    "name": "x",
                    "value": {
                      "type": "BinaryExpr",
                      "left": {
                        "type": "IdentExpr",
                        "name": "x"
                      },
                      "operator": "+",
                      "right": {
                        "type": "Literal",
                        "value": 1
                      }
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    ]
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 24;
      ENTER_SCOPE { num = 1 };
      LDC (Int 0);
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 10);
      BINOP LessThan;
      JOF 19;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 1);
      BINOP Add;
      ASSIGN { frame_index = 3; value_index = 0 };
      EXIT_SCOPE;
      POP;
      GOTO 7;
      LDC Undefined;
      FREE { pos = { frame_index = 3; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      LD { pos = { frame_index = 1; value_index = 0 } };
      CALL 0;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "while loop incrementing mutable variable" expected result

let test_if_else_mutable () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "main",
        "params": [],
        "returnType": null,
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "LetDecl",
              "name": "x",
              "value": {
                "type": "Literal",
                "value": 0
              },
              "declaredType": {
                "type": "BasicType",
                "name": "i32"
              },
              "isMutable": true
            },
            {
              "type": "IfExpr",
              "condition": {
                "type": "BinaryExpr",
                "left": {
                  "type": "IdentExpr",
                  "name": "x"
                },
                "operator": "<",
                "right": {
                  "type": "Literal",
                  "value": 10
                }
              },
              "thenBranch": {
                "type": "Block",
                "statements": [
                  {
                    "type": "AssignmentStmt",
                    "name": "x",
                    "value": {
                      "type": "BinaryExpr",
                      "left": {
                        "type": "IdentExpr",
                        "name": "x"
                      },
                      "operator": "+",
                      "right": {
                        "type": "Literal",
                        "value": 1
                      }
                    }
                  }
                ]
              },
              "elseBranch": {
                "type": "Block",
                "statements": [
                  {
                    "type": "AssignmentStmt",
                    "name": "x",
                    "value": {
                      "type": "BinaryExpr",
                      "left": {
                        "type": "IdentExpr",
                        "name": "x"
                      },
                      "operator": "-",
                      "right": {
                        "type": "Literal",
                        "value": 1
                      }
                    }
                  }
                ]
              }
            },
            {
              "type": "MacroCall",
              "name": "println",
              "args": [
                {
                  "type": "IdentExpr",
                  "name": "x"
                }
              ]
            }
          ]
        }
      }
    ]
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 32;
      ENTER_SCOPE { num = 1 };
      LDC (Int 0);
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 10);
      BINOP LessThan;
      JOF 18;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 1);
      BINOP Add;
      ASSIGN { frame_index = 3; value_index = 0 };
      EXIT_SCOPE;
      GOTO 24;
      ENTER_SCOPE { num = 0 };
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 1);
      BINOP Subtract;
      ASSIGN { frame_index = 3; value_index = 0 };
      EXIT_SCOPE;
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      LD { pos = { frame_index = 3; value_index = 0 } };
      CALL 1;
      FREE { pos = { frame_index = 3; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      LD { pos = { frame_index = 1; value_index = 0 } };
      CALL 0;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "if-else modifying mutable variable" expected result

let test_basic_arithmetic () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "main",
        "params": [],
        "returnType": null,
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "LetDecl",
              "name": "x",
              "value": {
                "type": "Literal",
                "value": 11
              },
              "declaredType": {
                "type": "BasicType",
                "name": "i32"
              },
              "isMutable": false
            },
            {
              "type": "MacroCall",
              "name": "println",
              "args": [
                {
                  "type": "IdentExpr",
                  "name": "x"
                }
              ]
            }
          ]
        }
      }
    ]
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 14;
      ENTER_SCOPE { num = 1 };
      LDC (Int 11);
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      LD { pos = { frame_index = 3; value_index = 0 } };
      CALL 1;
      FREE { pos = { frame_index = 3; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      LD { pos = { frame_index = 1; value_index = 0 } };
      CALL 0;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "basic arithmetic operations" expected result


let test_nested_blocks () =
  let json =
    {|{
    "type": "Program",
    "statements": [
      {
        "type": "FnDecl",
        "name": "main",
        "params": [],
        "returnType": null,
        "body": {
          "type": "Block",
          "statements": [
            {
              "type": "LetDecl",
              "name": "x",
              "value": {
                "type": "Literal",
                "value": 1
              },
              "declaredType": {
                "type": "BasicType",
                "name": "i32"
              },
              "isMutable": false
            },
            {
              "type": "Block",
              "statements": [
                {
                  "type": "LetDecl",
                  "name": "y",
                  "value": {
                    "type": "BinaryExpr",
                    "left": {
                      "type": "IdentExpr",
                      "name": "x"
                    },
                    "operator": "+",
                    "right": {
                      "type": "Literal",
                      "value": 2
                    }
                  },
                  "declaredType": {
                    "type": "BasicType",
                    "name": "i32"
                  },
                  "isMutable": false
                },
                {
                  "type": "MacroCall",
                  "name": "println",
                  "args": [
                    {
                      "type": "IdentExpr",
                      "name": "y"
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
    ]
  }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 22;
      ENTER_SCOPE { num = 1 };
      LDC (Int 1);
      ASSIGN { frame_index = 3; value_index = 0 };
      POP;
      ENTER_SCOPE { num = 1 };
      LD { pos = { frame_index = 3; value_index = 0 } };
      LDC (Int 2);
      BINOP Add;
      ASSIGN { frame_index = 4; value_index = 0 };
      POP;
      LD { pos = { frame_index = 0; value_index = 0 } };
      LD { pos = { frame_index = 4; value_index = 0 } };
      CALL 1;
      FREE { pos = { frame_index = 4; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      FREE { pos = { frame_index = 3; value_index = 0 }; to_free = true };
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 1; value_index = 0 };
      LD { pos = { frame_index = 1; value_index = 0 } };
      CALL 0;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested blocks with variable scoping" expected result

(* ---------- Run tests ---------- *)

let () =
  let open Alcotest in
  run "Compiler Tests"
    [
      ( "compiler",
        [
          test_case "factorial function" `Quick test_factorial;
          test_case "ownership transfer" `Quick test_ownership_transfer;
          test_case "while loop increment" `Quick test_while_loop_increment;
          test_case "if-else mutable" `Quick test_if_else_mutable;
          test_case "basic arithmetic" `Quick test_basic_arithmetic;
          test_case "nested blocks" `Quick test_nested_blocks;
        ] );
    ]
