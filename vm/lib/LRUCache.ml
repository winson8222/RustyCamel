module type LRU = sig
  type key
  type 'v t

  val create : int -> 'v t
  val find : 'v t -> key -> 'v option
  val add : 'v t -> key -> 'v -> unit
  val length : 'v t -> int
end

module Make (K : Hashtbl.HashedType) : LRU with type key = K.t = struct
  module H = Hashtbl.Make (K)

  type key = K.t
  type 'v t = { table : 'v H.t; order : key Queue.t; max_size : int }

  let create max_size =
    { table = H.create max_size; order = Queue.create (); max_size }

  let find lru key =
    match H.find_opt lru.table key with
    | Some v ->
        let temp = Queue.create () in
        Queue.iter
          (fun k -> if not (K.equal k key) then Queue.add k temp)
          lru.order;
        Queue.clear lru.order;
        Queue.transfer temp lru.order;
        Queue.add key lru.order;
        Some v
    | None -> None

  let add lru key value =
    if H.mem lru.table key then (
      H.replace lru.table key value;
      let temp = Queue.create () in
      Queue.iter
        (fun k -> if not (K.equal k key) then Queue.add k temp)
        lru.order;
      Queue.clear lru.order;
      Queue.transfer temp lru.order;
      Queue.add key lru.order)
    else (
      if H.length lru.table >= lru.max_size then (
        let oldest_key = Queue.take lru.order in
        H.remove lru.table oldest_key);
      H.add lru.table key value;
      Queue.add key lru.order)

  let length lru = H.length lru.table
end