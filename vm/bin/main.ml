open Vm.Compiler
(* For printing instruction *)


let () = 
  let test_json = "{\"tag\": \"blk\", \"body\": {\"tag\": \"seq\", \"stmts\": [{\"tag\": \"let\", \"sym\": \"y\", \"expr\": {\"tag\": \"lit\", \"val\": 4}}, {\"tag\": \"binop\", \"sym\": \"*\", \"frst\": {\"tag\": \"lit\", \"val\": \"3\"}, \"scnd\": {\"tag\": \"lit\", \"val\": 2}}]}}" in
  let instructions = compile_program test_json in
  List.iter (fun instr -> 
      Printf.printf "%s\n" (string_of_instruction instr)
    ) instructions;
  ()