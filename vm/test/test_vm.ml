open Vm.Compiler
open OUnit2

(* Helper Functions *)
let print_instructions instrs =
  List.iter (fun instr -> print_endline (string_of_instruction instr)) instrs

let assert_instructions_equal expected actual =
  assert_equal ~printer:(fun instrs -> String.concat "\n" (List.map string_of_instruction instrs)) expected actual

(* Test Cases *)
module TestCases = struct
  (* Simple literal example *)
  let sample_literal_1 = "{\"tag\": \"blk\", \"body\": {\"tag\": \"lit\", \"val\": 1}}"
  let sample_literal_1_expected_instrs = [
    ENTER_SCOPE { num = 0 };
    LDC (Int 1);
    EXIT_SCOPE;
    DONE
  ]

  (* Example with const and name reference *)
  let sample_const_and_nam = "{\"tag\": \"blk\", \"body\": {\"tag\": \"seq\", \"stmts\": [{\"tag\": \"const\", \"sym\": \"y\", \"expr\": {\"tag\": \"lit\", \"val\": 4}}, {\"tag\": \"binop\", \"sym\": \"*\", \"frst\": {\"tag\": \"nam\", \"sym\": \"y\"}, \"scnd\": {\"tag\": \"lit\", \"val\": 2}}]}}"
  let sample_const_and_nam_expected_instrs = [
    ENTER_SCOPE { num = 1 };
    LDC (Int 4);
    ASSIGN { pos = { frame_index = 1; value_index = 0 } };
    POP;
    LD { sym = "y"; pos = { frame_index = 1; value_index = 0 } };
    LDC (Int 2);
    BINOP { sym = "*" };
    EXIT_SCOPE;
    DONE
  ]

  (* Example with let and name reference *)
  let sample_let_and_nam = "{\"tag\": \"blk\", \"body\": {\"tag\": \"seq\", \"stmts\": [{\"tag\": \"let\", \"sym\": \"y\", \"expr\": {\"tag\": \"lit\", \"val\": 4}}, {\"tag\": \"binop\", \"sym\": \"*\", \"frst\": {\"tag\": \"nam\", \"sym\": \"y\"}, \"scnd\": {\"tag\": \"lit\", \"val\": 2}}]}}"

  (* Sample compiled instruction *)
  let sample_instrs = [
    ENTER_SCOPE {num = 1};
    ASSIGN {pos = { frame_index = 0; value_index = 0 }};
    POP;
    (LDC (String "3"));
    (LDC (Int 2));
    BINOP {sym = "*"};
    EXIT_SCOPE;
    DONE;
  ]
end

(* Test Functions *)
let test_literal_1 _ =
  let instrs = compile_program TestCases.sample_literal_1 in
  assert_instructions_equal TestCases.sample_literal_1_expected_instrs instrs

let test_const_and_nam _ =
  let instrs = compile_program TestCases.sample_const_and_nam in
  assert_instructions_equal TestCases.sample_const_and_nam_expected_instrs instrs

(* Main Test Suite *)
let suite = "VM Tests" >::: [
  "Literal 1" >:: test_literal_1;
  "Const and Name" >:: test_const_and_nam;
]

(* Run Tests *)
let () = run_test_tt_main suite