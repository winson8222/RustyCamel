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

let rec of_json (json : Yojson.Basic.t) : value_type =
  let open Yojson.Basic.Util in
  let get_assoc_field name fields = List.assoc_opt name fields in

  let parse_basic fields =
    match get_assoc_field "value" fields with
    | Some (`String s) -> of_string s
    | _ -> failwith "Invalid basic type: missing or invalid value"
  in

  let parse_ref fields =
    match get_assoc_field "value" fields with
    | Some value ->
        let is_mutable =
          get_assoc_field "is_mutable" fields
          |> Option.value ~default:(`Bool false)
          |> to_bool
        in
        TRef { is_mutable; base = of_json value }
    | _ -> failwith "Invalid ref type: missing value"
  in

  let parse_function fields =
    match (get_assoc_field "ret" fields, get_assoc_field "prms" fields) with
    | Some ret, Some prms ->
        let params = to_list prms |> List.map of_json in
        TFunction { ret = of_json ret; prms = params }
    | _ -> failwith "Invalid function type: missing ret or prms"
  in

  match json with
  | `String s -> of_string s
  | `Assoc fields -> (
      match get_assoc_field "kind" fields with
      | Some (`String "basic") -> parse_basic fields
      | Some (`String "ref") -> parse_ref fields
      | Some (`String "function") -> parse_function fields
      | _ -> failwith "Invalid type: unknown or missing kind")
  | _ -> failwith "Invalid type format"
