type ref_type = {
  is_mutable : bool;
  base : value_type; (* TODO: Add lifetime *)
}

and function_type = { ret : value_type; prms : value_type list }

and value_type =
  | TInt
  | TFloat
  | TString
  | TBoolean
  | TUndefined
  | TRef of ref_type
  | TFunction of function_type
[@@deriving show]

type lit_value =
  | Int of int
  | Float of float
  | String of string
  | Boolean of bool
  | Undefined
[@@deriving show]

let is_type_implement_copy typ =
  match typ with
  | TInt | TFloat | TBoolean | TUndefined -> true
  | TRef _ | TFunction _ | TString -> false
