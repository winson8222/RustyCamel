type builtin = {
  name : string;
  id : int;
  param_types : Types.value_type list list;
  ret_type : Types.value_type;
}

let builtin_list =
  ref
    [
      {
        name = "println";
        id = 0;
        param_types =
          [ [ Types.TString; Types.TInt; Types.TFloat; Types.TBoolean ] ];
        ret_type = Types.TUndefined;
      };
    ]

let register_builtin ~name ~param_types ~ret_type =
  let id = List.length !builtin_list in
  let entry = { name; id; param_types; ret_type } in
  builtin_list := !builtin_list @ [ entry ];
  entry

let all_builtins () = !builtin_list
let is_builtin_name name = List.exists (fun b -> b.name = name) !builtin_list

let get_builtin_name_by_id id =
  List.find (fun b -> b.id = id) !builtin_list |> fun b -> b.name

let get_builtin_id_by_name name =
  List.find (fun b -> b.name = name) !builtin_list |> fun b -> b.id

let get_builtin_param_types id =
  List.find (fun b -> b.id = id) !builtin_list |> fun b -> b.param_types

let get_builtin_ret_type id =
  List.find (fun b -> b.id = id) !builtin_list |> fun b -> b.ret_type

let is_valid_param_type param_types value_type =
  List.exists (fun t -> t = value_type) param_types

let validate_builtin_args builtin_id arg_types =
  let param_types = get_builtin_param_types builtin_id in
  if List.length arg_types <> List.length param_types then false
  else
    List.for_all2
      (fun arg_type param_types -> is_valid_param_type param_types arg_type)
      arg_types param_types
