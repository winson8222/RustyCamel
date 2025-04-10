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

let of_string s =
  match s with
  | "string" -> TString
  | "int" -> TInt
  | "boolean" -> TBoolean
  | "undefined" -> TUndefined
  | other -> failwith (Printf.sprintf "unknown type: %s" other)

let rec of_json (json : Yojson.Basic.t) =
  let open Yojson.Basic.Util in
  match json with
  | `String s -> of_string s (* Handle simple string types directly *)
  | `Assoc fields -> (
      match List.assoc_opt "kind" fields with
      | Some (`String "basic") -> (
          match List.assoc_opt "value" fields with
          | Some (`String s) -> of_string s
          | _ -> failwith "Invalid basic type: missing or invalid value")
      | Some (`String "ref") -> (
          match
            (List.assoc_opt "value" fields, List.assoc_opt "is_mutable" fields)
          with
          | Some value, mutable_field ->
              let is_mut =
                Option.value ~default:(`Bool false) mutable_field |> to_bool
              in
              TRef { is_mutable = is_mut; base = of_json value }
          | _ -> failwith "Invalid ref type: missing value")
      | Some (`String "function") -> (
          match (List.assoc_opt "ret" fields, List.assoc_opt "prms" fields) with
          | Some ret, Some prms ->
              TFunction
                { ret = of_json ret; prms = to_list prms |> List.map of_json }
          | _ -> failwith "Invalid function type: missing ret or prms")
      | _ -> failwith "Invalid type: unknown or missing kind")
  | _ -> failwith "Invalid type format"
