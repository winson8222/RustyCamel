module type LRU = sig
  type key
  type 'a t
  val create : int -> 'a t
  val find : 'a t -> key -> 'a option
  val add : 'a t -> key -> 'a -> unit
  val length : 'a t -> int
end

module Make (K : Hashtbl.HashedType) : LRU with type key = K.t