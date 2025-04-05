open Vm

let test_buffer = Buffer.create 8

let test_uint8 () =
  Buffer.set_uint8_at_offset test_buffer 0 42;
  Alcotest.(check int)
    "uint8 value" 42
    (Buffer.get_uint8_at_offset test_buffer 0)

let test_max_uint8 () =
  let test_buffer = Buffer.create 1 in
  Buffer.set_uint8_at_offset test_buffer 0 255;
  let value = Buffer.get_uint8_at_offset test_buffer 0 in
  Alcotest.(check int) "max uint8 value" 255 value

let test_uint16 () =
  Buffer.set_uint16_at_offset test_buffer 0 42;
  Alcotest.(check int)
    "uint16 value" 42
    (Buffer.get_uint16_at_offset test_buffer 0)

let test_max_uint16 () =
  let max_uint16 = (1 lsl 16) - 1 in
  (* 65535 *)
  let test_buffer = Buffer.create 2 in
  Buffer.set_uint16_at_offset test_buffer 0 max_uint16;
  let value = Buffer.get_uint16_at_offset test_buffer 0 in
  Alcotest.(check int) "max uint16 value" max_uint16 value

let test_int32 () =
  Buffer.set_int32_at_offset test_buffer 0 42l;
  Alcotest.(check int32)
    "int32 value" 42l
    (Buffer.get_int32_at_offset test_buffer 0)

let test_max_int32 () =
  let max_int32 = Int32.(sub (shift_left 1l 31) 1l) in
  (* Int32.max_int = 2^31 - 1 *)
  let test_buffer = Buffer.create 4 in
  Buffer.set_int32_at_offset test_buffer 0 max_int32;
  let value = Buffer.get_int32_at_offset test_buffer 0 in
  Alcotest.(check int32) "max int32 value" max_int32 value

let float_tolerance_value = 0.00001

let test_float64 () =
  Buffer.set_float64_at_offset test_buffer 0 42.0;
  Alcotest.(check (float float_tolerance_value))
    "float64 value" 42.0
    (Buffer.get_float64_at_offset test_buffer 0)

let test_mixed_types () =
  let buffer = Buffer.create 16 in
  Buffer.set_uint8_at_offset buffer 0 255;
  Buffer.set_uint16_at_offset buffer 1 65535;
  Buffer.set_int32_at_offset buffer 3 12345678l;
  Buffer.set_float64_at_offset buffer 7 3.14159;

  Alcotest.(check int) "uint8" 255 (Buffer.get_uint8_at_offset buffer 0);
  Alcotest.(check int) "uint16" 65535 (Buffer.get_uint16_at_offset buffer 1);
  Alcotest.(check int32) "int32" 12345678l (Buffer.get_int32_at_offset buffer 3);
  Alcotest.(check (float float_tolerance_value))
    "float64" 3.14159
    (Buffer.get_float64_at_offset buffer 7)

let test_overwrite () =
  let buffer = Buffer.create 8 in
  Buffer.set_uint8_at_offset buffer 0 100;
  Buffer.set_uint8_at_offset buffer 0 42;
  (* overwrite *)
  Alcotest.(check int)
    "uint8 overwrite" 42
    (Buffer.get_uint8_at_offset buffer 0)

let test_sequential_write_read () =
  let buffer = Buffer.create 18 in
  Buffer.set_uint8_at_offset buffer 0 1;
  Buffer.set_uint8_at_offset buffer 1 2;
  Buffer.set_uint16_at_offset buffer 2 300;
  Buffer.set_float64_at_offset buffer 8 99.99;

  Alcotest.(check int) "u8 0" 1 (Buffer.get_uint8_at_offset buffer 0);
  Alcotest.(check int) "u8 1" 2 (Buffer.get_uint8_at_offset buffer 1);
  Alcotest.(check int) "u16" 300 (Buffer.get_uint16_at_offset buffer 2);
  Alcotest.(check (float float_tolerance_value))
    "float64" 99.99
    (Buffer.get_float64_at_offset buffer 8)

let () =
  Printf.printf "Starting test_bufferfer tests\n";
  let open Alcotest in
  run "Buffer"
    [
      ( "uint8",
        [
          test_case "Set/get uint8" `Quick test_uint8;
          test_case "Set/get max uint8" `Quick test_max_uint8;
        ] );
      ( "int32",
        [
          test_case "Set/get int32" `Quick test_int32;
          test_case "Set/get max int32" `Quick test_max_int32;
        ] );
      ( "in16",
        [
          test_case "Set/get int16" `Quick test_uint16;
          test_case "Set/get max int16" `Quick test_max_uint16;
        ] );
      ("float64", [ test_case "Set/get float64" `Quick test_float64 ]);
      ( "mixed",
        [
          test_case "Mixed types" `Quick test_mixed_types;
          test_case "Overwrite test" `Quick test_overwrite;
          test_case "Sequential write/read" `Quick test_sequential_write_read;
        ] );
    ]
