type expr =
  | Const of int
  | Var of string
  | Sub of expr * expr
type lin_eq = int * string * int

let rec solve e =
  match e with
  | Const n -> [(0,"",n)]
  | Var v -> [(1,v,0)]
  | Sub (e1,e2) ->
      let eqs1 = solve e1 in
      let eqs2 = solve e2 in
      let rec merge_eqs eqs1 eqs2 =
        match eqs1,eqs2 with
        | [],[] -> []
        | [],(a,v,b)::t -> ((-a),v,(-b)) :: merge_eqs [] t
        | h::t,[] -> h :: merge_eqs t []
        | (_,v1,_) as h1::t1,(_,v2,_)::t2 when v1 < v2 -> h1 :: merge_eqs t1 eqs2
        | (_,v1,_)::t1,(a,v2,b)::t2 when v2 < v1 ->  ((-a),v2,(-b)):: merge_eqs eqs1 t2
        | (a1,v,b1)::t1,(a2,_,b2)::t2 -> (a1-a2,v,b1-b2) :: merge_eqs t1 t2 in
      merge_eqs eqs1 eqs2

let eq_to_string eq =
  let a,v,b = eq in
  Printf.sprintf "%d%s %d" a v b
let () =
  let e1 = (Sub (Var "x", (Sub (Sub (Var "x",Var "y"), (Sub (Var "z",Var "x")))))) in
  List.iter (Printf.printf "%s\n") (List.map eq_to_string (solve e1))
