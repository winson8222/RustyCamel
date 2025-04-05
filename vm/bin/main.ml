open Vm.Compiler
(* For printing instruction *)

let () =
  let test_json =
    "{\"tag\": \"blk\", \"body\": {\"tag\": \"lit\", \"val\": 1}}"
  in
  let instructions = compile_program test_json in
  List.iter
    (fun instr -> Printf.printf "%s\n" (string_of_instruction instr))
    instructions;
  Printf.printf "starting runner\n";
  let runner = Vm.Runner.create () in
  let program_result = Vm.Runner.run runner instructions in
  match program_result with
  | Ok res -> Printf.printf "%s\n" (Vm.Runner.string_of_vm_value res)
  | Error e ->
      Printf.printf "%s\n" (Vm.Runner.string_of_vm_error e);
      ()
