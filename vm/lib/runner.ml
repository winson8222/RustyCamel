type vm_value =
  | VNumber of int
  | VString of string
  | VUndefined

type vm_error =
  | TypeError of string

let run _instrs = 
  Ok (VNumber 1)
