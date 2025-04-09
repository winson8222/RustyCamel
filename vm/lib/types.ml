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

open Yojson.Basic.Util

let rec of_json type_json =
  match type_json with
  | `Null -> failwith "Type not provided"
  | `String value -> (
      match value with
      | "string" -> TString
      | "int" -> TInt
      | "boolean" -> TBoolean
      | "undefined" -> TUndefined
      | other -> failwith (Printf.sprintf "unknown type: %s" other))
  | `Assoc fields ->
      (* Extract ret and prms from the assoc, expecting both to exist *)
      let ret_type =
        try List.assoc "ret" fields |> of_json
        with Not_found -> failwith "Missing 'ret' field in function type"
      in
      let prms_types =
        match List.assoc_opt "prms" fields with
        | Some prms_json -> prms_json |> to_list |> List.map of_json
        | None -> [] (* Default to empty list if no parameters are provided *)
      in
      TFunction { ret = ret_type; prms = prms_types }
  | other -> failwith (Printf.sprintf "unknown type: %s" (Yojson.Basic.to_string other))
