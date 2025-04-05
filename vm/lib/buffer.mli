type t

(* Check the BigArray 'kind' *)
(* address: int*)
val create : int -> t
val get_int32_at_offset : t -> int -> int32
val set_int32_at_offset : t -> int -> int32 -> unit
val get_float64_at_offset : t -> int -> float
val set_float64_at_offset : t -> int -> float -> unit
val get_uint8_at_offset : t -> int -> int
val set_uint8_at_offset : t -> int -> int -> unit
val get_uint16_at_offset : t -> int -> int
val set_uint16_at_offset : t -> int -> int -> unit
