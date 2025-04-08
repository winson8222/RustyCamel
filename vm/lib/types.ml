type ref_type = {
  is_mutable : bool;
  base : value_type; (* TODO: Add lifetime *)
}

and value_type =
  | TInt
  | TString
  | TBoolean
  | TUndefined
  | TRef of ref_type
  | TFunction of value_type list * value_type
  | TArray of value_type * int (* Fixed size arrays *)
[@@deriving show]

let of_string str =
  match str with
  | "string" -> TString
  | "int" -> TInt
  | "boolean" -> TBoolean
  | "undefined" -> TUndefined
  | _ -> failwith "unknown "
