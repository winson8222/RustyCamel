type ref_type = {
  is_mutable : bool;
  base : value_type; (* TODO: Add lifetime *)
}

and function_type = { ret : value_type; prms : value_type list }

and value_type =
  | TInt
  | TString
  | TBoolean
  | TUndefined
  | TRef of ref_type
  | TFunction of function_type
  | TArray of value_type * int (* Fixed size arrays *)
[@@deriving show]

let of_string str =
  match str with
  | "string" -> TString
  | "int" -> TInt
  | "boolean" -> TBoolean
  | "undefined" -> TUndefined
  | _ -> failwith "unknown "
