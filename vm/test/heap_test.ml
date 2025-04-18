open Vm.Heap 

(* Custom float testable with tolerance *)
let test_float =  (* renamed to avoid conflict *)
  let module M = struct
    type t = float
    let equal a b = abs_float (a -. b) < 0.001
    let pp formatter t = Format.fprintf formatter "%f" t
  end in
  (module M: Alcotest.TESTABLE with type t = float)

let test_heap_allocate_number () =
  let heap = create () in
  let num = 42.0 in
  let addr = heap_allocate_number heap num in
  let value = heap_get_number_value heap addr in
  Alcotest.(check test_float) "same number" num value

let test_heap_allocate_string () =
  let heap = create () in
  let str = "hello" in
  let addr = heap_allocate_string heap str in
  let value = heap_get_string_value heap addr in
  Alcotest.(check string) "same string" str value

let test_heap_allocate_ref () =
  let heap = create () in
  let num = 42.0 in
  let num_addr = heap_allocate_number heap num in
  let ref_addr = heap_allocate_ref heap (Float.of_int num_addr) in
  let pointed_addr = heap_get_ref_value heap ref_addr in
  let value = heap_get_number_value heap pointed_addr in
  Alcotest.(check test_float) "same number through ref" num value

let test_heap_environment () =
  let heap = create () in
  let env_addr = heap_allocate_environment heap ~num_frames:2 in
  let size = heap_get_size heap env_addr in
  Alcotest.(check int) "environment size" 3 size;
  let tag = heap_get_tag heap env_addr in
  Alcotest.(check bool) "is environment" true (tag = Environment_tag)

let test_heap_frame () =
  let heap = create () in
  let frame_addr = heap_allocate_frame heap ~num_values:3 in
  let size = heap_get_size heap frame_addr in
  Alcotest.(check int) "frame size" 4 size;
  let tag = heap_get_tag heap frame_addr in
  Alcotest.(check bool) "is frame" true (tag = Frame_tag)

let test_heap_allocate_callframe () = 
    let heap = create () in 
    let callframe_addr = heap_allocate_callframe heap ~pc:12 ~env_addr:20 in
    let res_env =heap_get_callframe_env heap callframe_addr in 
    Alcotest.(check int) "callframe env" 20 res_env;
    let res_pc =heap_get_callframe_pc heap callframe_addr in
    Alcotest.(check int) "callframe pc" 12 res_pc
(* 
let test_heap_free () =
  let heap = create () in
  let addr = heap_allocate_number heap 42.0 in
  let old_free = !(heap.free) in
  heap_free heap addr;
  Alcotest.(check int) "free pointer updated" addr !(heap.free);
  Alcotest.(check float) "points to old free" 
    (Float.of_int old_free) 
    (heap_get heap addr) *)

(* let test_heap_canonical_values () =
  let heap = create () in
  let values = get_canonical_values heap in
  let check_tag addr expected_tag =
    Alcotest.(check bool) 
      (Printf.sprintf "is %s" (string_of_node_tag expected_tag))
      true
      (heap_get_tag heap addr = expected_tag)
  in
  check_tag values.true_addr True_tag;
  check_tag values.false_addr False_tag;
  check_tag values.undefined_addr Undefined_tag;
  check_tag values.unassigned_addr Unassigned_tag *)

let () =
  let open Alcotest in
  run "Heap" [
    ( "heap operations",
      [
        test_case "allocate number" `Quick test_heap_allocate_number;
        test_case "allocate string" `Quick test_heap_allocate_string;
        test_case "allocate ref" `Quick test_heap_allocate_ref;
        test_case "environment" `Quick test_heap_environment;
        test_case "frame" `Quick test_heap_frame;
        test_case "test_heap_allocate_callframe" `Quick test_heap_allocate_callframe
        (* test_case "free" `Quick test_heap_free; *)
        (* test_case "canonical values" `Quick test_heap_canonical_values; *)
      ] );
  ]