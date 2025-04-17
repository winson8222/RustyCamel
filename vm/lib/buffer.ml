open Bigarray

type t = (int, int8_unsigned_elt, c_layout) Array1.t

let create size_bytes = Array1.create int8_unsigned c_layout size_bytes

let get_int32_at_offset buffer offset =
  (* num int8 indices for int 32 = 4*)
  let ba = Array1.sub buffer offset 4 in
  Array1.unsafe_get (Obj.magic ba : (int32, int32_elt, c_layout) Array1.t) 0

let set_int32_at_offset buffer offset value =
  let ba = Array1.sub buffer offset 4 in
  Array1.unsafe_set
    (Obj.magic ba : (int32, int32_elt, c_layout) Array1.t)
    0 value

let get_float64_at_offset buffer offset =
  (* num int8 indices for int 32 = 8 *)
  let ba = Array1.sub buffer offset 8 in
  Array1.unsafe_get (Obj.magic ba : (float, float64_elt, c_layout) Array1.t) 0

let set_float64_at_offset buffer offset value =
  let ba = Array1.sub buffer offset 8 in
  Array1.unsafe_set
    (Obj.magic ba : (float, float64_elt, c_layout) Array1.t)
    0 value

let get_uint8_at_offset buffer offset = Array1.get buffer offset
let set_uint8_at_offset buffer offset value = Array1.set buffer offset value

let get_uint16_at_offset buffer offset =
  (* num int8 indices for int 32 = 2 *)
  let ba = Array1.sub buffer offset 2 in
  Array1.unsafe_get
    (Obj.magic ba : (int, int16_unsigned_elt, c_layout) Array1.t)
    0

let set_uint16_at_offset buffer offset value =
  let ba = Array1.sub buffer offset 2 in
  Array1.unsafe_set
    (Obj.magic ba : (int, int16_unsigned_elt, c_layout) Array1.t)
    0 value
