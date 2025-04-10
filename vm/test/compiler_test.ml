open Vm.Compiler
open Vm.Value

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
        { "tag": "let", "sym": "x", 
          "expr": { "tag": "lit", "val": 4 }, 
          "declared_type": {
              "kind": "basic",
              "value": "int"
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
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "block with let x" expected result

let test_ld_variable () =
  let json =
    {|{"tag": "blk", "body": {"tag": "seq", "stmts": [{"tag": "let", "sym": "x", "expr": {"tag": "lit", "val": 4}, "declared_type": {"kind": "basic", "value": "int"}}, {"tag": "nam", "sym": "x"}]}}|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDC (Int 4);
      ASSIGN { frame_index = 0; value_index = 0 };
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
          "tag": "blk",
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
        }, 
        "declared_type": {
          "kind": "function",
          "ret": "int",
          "prms": []
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 0; addr = 3 };
      GOTO 9;
      ENTER_SCOPE { num = 0 };
      LDC (Int 1);
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
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
          { "name": "x" },
          { "name": "y" }
        ],
        "body": {
          "tag": "blk",
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
        },
         "declared_type": {
          "kind": "function", 
          "ret": "int",
          "prms": ["int", "int"]
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
      ENTER_SCOPE { num = 0 };
      LDC (Int 1);
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function declaration with parameters" expected result

let test_function_with_binop () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "fun",
        "sym": "f",
        "prms": [
          { "name": "x" },
          { "name": "y" }
        ],
        "body": {
          "tag": "blk",
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
        },
         "declared_type": {
         "kind": "function",
          "ret": "int",
          "prms": ["int", "int"]
        }
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 2; addr = 3 };
      GOTO 11;
      ENTER_SCOPE { num = 0 };
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
      BINOP { sym = "+" };
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
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
          { "name": "x" },
          { "name": "y" }
        ],
        "declared_type": {
        "kind": "function",
          "ret": "int",
          "prms": ["int", "int"]
        },
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
                },
                "declared_type": {
                  "kind": "basic",
                  "value": "int"
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
      ASSIGN { frame_index = 2; value_index = 0 };
      POP;
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
      BINOP { sym = "+" };
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function with block and const" expected result

let test_function_application () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "blk",
              "body": {
                "tag": "ret",
                "expr": {
                  "tag": "binop",
                  "sym": "+",
                  "frst": { "tag": "nam", "sym": "x" },
                  "scnd": { "tag": "nam", "sym": "y" }
                }
              }
            },
             "declared_type": {
             "kind": "function",
              "ret": "int",
              "prms": ["int", "int"]
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 1 };
      LDF { arity = 2; addr = 3 };
      GOTO 11;
      ENTER_SCOPE { num = 0 };
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
      BINOP { sym = "+" };
      RESET;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
      LDC (Int 33);
      LDC (Int 22);
      CALL 2;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "function application" expected result

let test_nested_function_calls () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "k",
            "prms": [
              { "name": "x" }
            ],
            "body": {
              "tag": "ret",
              "expr": {
                "tag": "nam",
                "sym": "x"
              }
            },
            "declared_type": {
              "kind": "function",
              "ret": "int",
              "prms": ["int"]
            }
          },
          {
            "tag": "fun",
            "sym": "g",
            "prms": [
              { "name": "x" }
            ],
            "body": {
              "tag": "ret",
              "expr": {
                "tag": "nam",
                "sym": "x"
              }
            },
            "declared_type": {
            "kind": "function",
              "ret": "int",
              "prms": ["int"]
            }
          },
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "declared_type": {
            "kind": "function",
              "ret": "int",
              "prms": ["int", "int"]
            },
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
                    },
                    "declared_type": {
                      "kind": "basic",
                      "value": "int"
                    }
                  },
                  {
                    "tag": "ret",
                    "expr": {
                      "tag": "app",
                      "fun": {
                        "tag": "nam",
                        "sym": "g"
                      },
                      "args": [
                        {
                          "tag": "nam",
                          "sym": "x"
                        }
                      ]
                    }
                  }
                ]
              }
            }
          },
          {
            "tag": "app",
            "fun": {
              "tag": "nam",
              "sym": "f"
            },
            "args": [
              {
                "tag": "lit",
                "val": 33
              },
              {
                "tag": "lit",
                "val": 22
              }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected =
    [
      ENTER_SCOPE { num = 3 };
      (* Function k *)
      LDF { arity = 1; addr = 3 };
      GOTO 7;
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      RESET;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 0 };
      POP;
      (* Function g *)
      LDF { arity = 1; addr = 11 };
      GOTO 15;
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      RESET;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 1 };
      POP;
      (* Function f *)
      LDF { arity = 2; addr = 19 };
      GOTO 29;
      ENTER_SCOPE { num = 1 };
      LDC (Int 0);
      ASSIGN { frame_index = 2; value_index = 0 };
      POP;
      LD { sym = "g"; pos = { frame_index = 0; value_index = 1 } };
      LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
      TAILCALL 1;
      EXIT_SCOPE;
      LDC Undefined;
      RESET;
      ASSIGN { frame_index = 0; value_index = 2 };
      POP;
      (* Call f(33, 22) *)
      LD { sym = "f"; pos = { frame_index = 0; value_index = 2 } };
      LDC (Int 33);
      LDC (Int 22);
      CALL 2;
      EXIT_SCOPE;
      DONE;
    ]
  in
  check_instr_list "nested function calls with tail call" expected result

let test_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "cond",
                  "pred": {
                    "tag": "binop",
                    "sym": ">",
                    "frst": { "tag": "nam", "sym": "x" },
                    "scnd": { "tag": "lit", "val": 0 }
                  },
                  "cons": {
                    "tag": "blk",
                    "body": {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 0 }
                    }
                  },
                  "alt": {
                    "tag": "blk",
                    "body": {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 3 }
                    }
                  }
                },
                {
                  "tag": "ret",
                  "expr": {
                    "tag": "binop",
                    "sym": "-",
                    "frst": { "tag": "nam", "sym": "x" },
                    "scnd": { "tag": "nam", "sym": "y" }
                  }
                }
              ]
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 23;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 12;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 0 };
    EXIT_SCOPE;
    GOTO 16;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 2; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "conditional function with assignment" expected result

let test_conditional_function_with_returns () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "cond",
              "pred": {
                "tag": "binop",
                "sym": "<",
                "frst": { "tag": "nam", "sym": "y" },
                "scnd": { "tag": "lit", "val": 0 }
              },
              "cons": {
                "tag": "blk",
                "body": {
                  "tag": "seq",
                  "stmts": [
                    {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 0 }
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
              },
              "alt": {
                "tag": "blk",
                "body": {
                  "tag": "seq",
                  "stmts": [
                    {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 3 }
                    },
                    {
                      "tag": "ret",
                      "expr": {
                        "tag": "binop",
                        "sym": "-",
                        "frst": { "tag": "nam", "sym": "x" },
                        "scnd": { "tag": "nam", "sym": "y" }
                      }
                    }
                  ]
                }
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 28;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 17;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 26;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "conditional function with returns in both branches" expected result
  
let test_2_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "blk",
              "body": {
                "tag": "seq",
                "stmts": [
                  {
                    "tag": "const",
                    "sym": "k",
                    "expr": {
                      "tag": "binop",
                      "sym": "*",
                      "frst": { "tag": "lit", "val": 3 },
                      "scnd": { "tag": "nam", "sym": "x" }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": ">",
                      "frst": { "tag": "nam", "sym": "x" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 0 }
                      }
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 1 }
                      }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": "<",
                      "frst": { "tag": "nam", "sym": "y" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 0 }
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
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 3 }
                          },
                          {
                            "tag": "ret",
                            "expr": {
                              "tag": "binop",
                              "sym": "-",
                              "frst": { "tag": "nam", "sym": "x" },
                              "scnd": { "tag": "nam", "sym": "y" }
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 49;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    BINOP { sym = "*" };
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 18;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    GOTO 22;
    ENTER_SCOPE { num = 1 };
    LDC (Int 1);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 37;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 46;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "complex conditional function with multiple blocks and returns" expected result

let test_nested_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "blk",
              "body": {
                "tag": "seq",
                "stmts": [
                  {
                    "tag": "const",
                    "sym": "k",
                    "expr": {
                      "tag": "binop",
                      "sym": "*",
                      "frst": { "tag": "lit", "val": 3 },
                      "scnd": { "tag": "nam", "sym": "x" }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": ">",
                      "frst": { "tag": "nam", "sym": "x" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 0 }
                      }
                    },
                    "alt": {
                      "tag": "seq",
                      "stmts": [
                        {
                          "tag": "cond",
                          "pred": {
                            "tag": "binop",
                            "sym": ">",
                            "frst": { "tag": "nam", "sym": "x" },
                            "scnd": {
                              "tag": "unop",
                              "sym": "-unary",
                              "frst": { "tag": "lit", "val": 3 }
                            }
                          },
                          "cons": {
                            "tag": "blk",
                            "body": {
                              "tag": "seq",
                              "stmts": [
                                {
                                  "tag": "const",
                                  "sym": "m",
                                  "expr": { "tag": "lit", "val": 3 }
                                },
                                {
                                  "tag": "const",
                                  "sym": "n",
                                  "expr": { "tag": "lit", "val": 1 }
                                }
                              ]
                            }
                          },
                          "alt": {
                            "tag": "blk",
                            "body": {
                              "tag": "const",
                              "sym": "m",
                              "expr": { "tag": "lit", "val": 5 }
                            }
                          }
                        },
                        {
                          "tag": "ret",
                          "expr": { "tag": "lit", "val": 10 }
                        }
                      ]
                    }
                  },
                  {
                    "tag": "const",
                    "sym": "j",
                    "expr": { "tag": "lit", "val": 0 }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": "<",
                      "frst": { "tag": "nam", "sym": "y" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 0 }
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
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 3 }
                          },
                          {
                            "tag": "ret",
                            "expr": {
                              "tag": "binop",
                              "sym": "-",
                              "frst": { "tag": "nam", "sym": "x" },
                              "scnd": { "tag": "nam", "sym": "y" }
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 68;
    ENTER_SCOPE { num = 2 };
    LDC (Int 3);
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    BINOP { sym = "*" };
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 18;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    GOTO 38;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 3);
    UNOP { sym = "-unary" };
    BINOP { sym = ">" };
    JOF 31;
    ENTER_SCOPE { num = 2 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LDC (Int 1);
    ASSIGN { frame_index = 3; value_index = 1 };
    EXIT_SCOPE;
    GOTO 35;
    ENTER_SCOPE { num = 1 };
    LDC (Int 5);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LDC (Int 10);
    RESET;
    POP;
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 1 };
    POP;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 56;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 65;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "nested conditional function with multiple blocks and returns" expected result

let test_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "seq",
              "stmts": [
                {
                  "tag": "cond",
                  "pred": {
                    "tag": "binop",
                    "sym": ">",
                    "frst": { "tag": "nam", "sym": "x" },
                    "scnd": { "tag": "lit", "val": 0 }
                  },
                  "cons": {
                    "tag": "blk",
                    "body": {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 0 }
                    }
                  },
                  "alt": {
                    "tag": "blk",
                    "body": {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 3 }
                    }
                  }
                },
                {
                  "tag": "ret",
                  "expr": {
                    "tag": "binop",
                    "sym": "-",
                    "frst": { "tag": "nam", "sym": "x" },
                    "scnd": { "tag": "nam", "sym": "y" }
                  }
                }
              ]
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 23;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 12;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 0 };
    EXIT_SCOPE;
    GOTO 16;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 2; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "conditional function with assignment" expected result

let test_conditional_function_with_returns () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "cond",
              "pred": {
                "tag": "binop",
                "sym": "<",
                "frst": { "tag": "nam", "sym": "y" },
                "scnd": { "tag": "lit", "val": 0 }
              },
              "cons": {
                "tag": "blk",
                "body": {
                  "tag": "seq",
                  "stmts": [
                    {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 0 }
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
              },
              "alt": {
                "tag": "blk",
                "body": {
                  "tag": "seq",
                  "stmts": [
                    {
                      "tag": "const",
                      "sym": "z",
                      "expr": { "tag": "lit", "val": 3 }
                    },
                    {
                      "tag": "ret",
                      "expr": {
                        "tag": "binop",
                        "sym": "-",
                        "frst": { "tag": "nam", "sym": "x" },
                        "scnd": { "tag": "nam", "sym": "y" }
                      }
                    }
                  ]
                }
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 28;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 17;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 26;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "conditional function with returns in both branches" expected result
  
let test_2_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "blk",
              "body": {
                "tag": "seq",
                "stmts": [
                  {
                    "tag": "const",
                    "sym": "k",
                    "expr": {
                      "tag": "binop",
                      "sym": "*",
                      "frst": { "tag": "lit", "val": 3 },
                      "scnd": { "tag": "nam", "sym": "x" }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": ">",
                      "frst": { "tag": "nam", "sym": "x" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 0 }
                      }
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 1 }
                      }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": "<",
                      "frst": { "tag": "nam", "sym": "y" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 0 }
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
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 3 }
                          },
                          {
                            "tag": "ret",
                            "expr": {
                              "tag": "binop",
                              "sym": "-",
                              "frst": { "tag": "nam", "sym": "x" },
                              "scnd": { "tag": "nam", "sym": "y" }
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 49;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    BINOP { sym = "*" };
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 18;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    GOTO 22;
    ENTER_SCOPE { num = 1 };
    LDC (Int 1);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 37;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 46;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "complex conditional function with multiple blocks and returns" expected result

let test_nested_conditional_function () =
  let json =
    {|{
      "tag": "blk",
      "body": {
        "tag": "seq",
        "stmts": [
          {
            "tag": "fun",
            "sym": "f",
            "prms": [
              { "name": "x" },
              { "name": "y" }
            ],
            "body": {
              "tag": "blk",
              "body": {
                "tag": "seq",
                "stmts": [
                  {
                    "tag": "const",
                    "sym": "k",
                    "expr": {
                      "tag": "binop",
                      "sym": "*",
                      "frst": { "tag": "lit", "val": 3 },
                      "scnd": { "tag": "nam", "sym": "x" }
                    }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": ">",
                      "frst": { "tag": "nam", "sym": "x" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "const",
                        "sym": "m",
                        "expr": { "tag": "lit", "val": 0 }
                      }
                    },
                    "alt": {
                      "tag": "seq",
                      "stmts": [
                        {
                          "tag": "cond",
                          "pred": {
                            "tag": "binop",
                            "sym": ">",
                            "frst": { "tag": "nam", "sym": "x" },
                            "scnd": {
                              "tag": "unop",
                              "sym": "-unary",
                              "frst": { "tag": "lit", "val": 3 }
                            }
                          },
                          "cons": {
                            "tag": "blk",
                            "body": {
                              "tag": "seq",
                              "stmts": [
                                {
                                  "tag": "const",
                                  "sym": "m",
                                  "expr": { "tag": "lit", "val": 3 }
                                },
                                {
                                  "tag": "const",
                                  "sym": "n",
                                  "expr": { "tag": "lit", "val": 1 }
                                }
                              ]
                            }
                          },
                          "alt": {
                            "tag": "blk",
                            "body": {
                              "tag": "const",
                              "sym": "m",
                              "expr": { "tag": "lit", "val": 5 }
                            }
                          }
                        },
                        {
                          "tag": "ret",
                          "expr": { "tag": "lit", "val": 10 }
                        }
                      ]
                    }
                  },
                  {
                    "tag": "const",
                    "sym": "j",
                    "expr": { "tag": "lit", "val": 0 }
                  },
                  {
                    "tag": "cond",
                    "pred": {
                      "tag": "binop",
                      "sym": "<",
                      "frst": { "tag": "nam", "sym": "y" },
                      "scnd": { "tag": "lit", "val": 0 }
                    },
                    "cons": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 0 }
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
                    },
                    "alt": {
                      "tag": "blk",
                      "body": {
                        "tag": "seq",
                        "stmts": [
                          {
                            "tag": "const",
                            "sym": "z",
                            "expr": { "tag": "lit", "val": 3 }
                          },
                          {
                            "tag": "ret",
                            "expr": {
                              "tag": "binop",
                              "sym": "-",
                              "frst": { "tag": "nam", "sym": "x" },
                              "scnd": { "tag": "nam", "sym": "y" }
                            }
                          }
                        ]
                      }
                    }
                  }
                ]
              }
            }
          },
          {
            "tag": "app",
            "fun": { "tag": "nam", "sym": "f" },
            "args": [
              { "tag": "lit", "val": 33 },
              { "tag": "lit", "val": 22 }
            ]
          }
        ]
      }
    }|}
  in
  let result = compile_program json in
  let expected = [
    ENTER_SCOPE { num = 1 };
    LDF { arity = 2; addr = 3 };
    GOTO 68;
    ENTER_SCOPE { num = 2 };
    LDC (Int 3);
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    BINOP { sym = "*" };
    ASSIGN { frame_index = 2; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 0);
    BINOP { sym = ">" };
    JOF 18;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    GOTO 38;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 3);
    UNOP { sym = "-unary" };
    BINOP { sym = ">" };
    JOF 31;
    ENTER_SCOPE { num = 2 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LDC (Int 1);
    ASSIGN { frame_index = 3; value_index = 1 };
    EXIT_SCOPE;
    GOTO 35;
    ENTER_SCOPE { num = 1 };
    LDC (Int 5);
    ASSIGN { frame_index = 3; value_index = 0 };
    EXIT_SCOPE;
    POP;
    LDC (Int 10);
    RESET;
    POP;
    LDC (Int 0);
    ASSIGN { frame_index = 2; value_index = 1 };
    POP;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    LDC (Int 0);
    BINOP { sym = "<" };
    JOF 56;
    ENTER_SCOPE { num = 1 };
    LDC (Int 0);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "+" };
    RESET;
    EXIT_SCOPE;
    GOTO 65;
    ENTER_SCOPE { num = 1 };
    LDC (Int 3);
    ASSIGN { frame_index = 3; value_index = 0 };
    POP;
    LD { sym = "x"; pos = { frame_index = 1; value_index = 0 } };
    LD { sym = "y"; pos = { frame_index = 1; value_index = 1 } };
    BINOP { sym = "-" };
    RESET;
    EXIT_SCOPE;
    EXIT_SCOPE;
    LDC Undefined;
    RESET;
    ASSIGN { frame_index = 0; value_index = 0 };
    POP;
    LD { sym = "f"; pos = { frame_index = 0; value_index = 0 } };
    LDC (Int 33);
    LDC (Int 22);
    CALL 2;
    EXIT_SCOPE;
    DONE
  ] in
  check_instr_list "nested conditional function with multiple blocks and returns" expected result

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
          test_case "Function with parameters" `Quick test_function_with_params;
          test_case "function with binop parameters" `Quick
            test_function_with_binop;
          test_case "function with block and const" `Quick
            test_function_with_block_and_const;
          test_case "function application" `Quick test_function_application;
          test_case "nested function calls with tail call" `Quick test_nested_function_calls;
          test_case "conditional function with assignment" `Quick test_conditional_function;
          test_case "conditional function with returns" `Quick test_conditional_function_with_returns;
          test_case "2 conditional functions" `Quick test_2_conditional_function;
          test_case "nested conditional function" `Quick test_nested_conditional_function;
        ] );
    ]
