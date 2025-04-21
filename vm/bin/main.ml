open Vm.Compiler
(* For printing instruction *)

let () =
  let filename = "lib/ast.json" in
  let json = Yojson.Basic.from_file filename |> Yojson.Basic.to_string in
  let instructions = compile_program json in
  (* List.iteri
    (fun i instr ->
      Printf.printf "instr[%d]: %s\n" i (string_of_instruction instr))
    instructions; *)
  Printf.printf "starting runner\n";
  let runner = Vm.Runner.create () in
  let program_result = Vm.Runner.run runner instructions in
  match program_result with
  | Ok res ->
      Printf.printf "Program Result: %s\n" (Vm.Runner.string_of_vm_value res)
  | Error e ->
      Printf.printf "%s\n" (Vm.Runner.string_of_vm_error e);
      ()
