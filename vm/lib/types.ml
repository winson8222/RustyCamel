type ref_type = {
  is_mutable : bool;
  base : value_type; (* TODO: Add lifetime *)
}

and value_type =
  | TNumber
  | TString
  | TBoolean
  | TUndefined
  | TRef of ref_type
  | TFunction of value_type list * value_type
  | TArray of value_type * int (* Fixed size arrays *)

  let rec of_string str =
    match str with
    | "string" -> TString
    | "number" -> TNumber
    | "boolean" -> TBoolean
    | "undefined" -> TUndefined
    | s when String.starts_with ~prefix:"&" s ->
        let is_mut = String.starts_with ~prefix:"&mut" s in
        let base_type = String.sub s 
          (if is_mut then 5 else 1) 
          (String.length s - (if is_mut then 5 else 1)) in
        TRef { is_mutable = is_mut; base = of_string base_type }
    | s when String.starts_with ~prefix:"[" s ->
        let base_type_str = String.sub s 1 (String.index s ';' - 1) in
        let size_str = String.sub s 
          (String.index s ';' + 1)
          (String.length s - String.index s ';' - 2) in
        TArray (of_string base_type_str, int_of_string size_str)
    | s -> failwith ("Unknown type: " ^ s)