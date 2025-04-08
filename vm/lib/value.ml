type lit_value =
  | Int of int
  | String of string
  | Boolean of bool
  | Undefined
[@@deriving show]