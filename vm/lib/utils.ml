let find_index f ls =
  let rec find_index_helper ls f cur_index =
    match ls with
    | [] -> None
    | hd :: tl -> (
        match f hd with
        | true -> Some cur_index
        | false -> find_index_helper tl f (cur_index + 1))
  in
  find_index_helper ls f 0
