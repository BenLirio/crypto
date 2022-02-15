type expr =
  | Const of int
  | Var of string
  | Sub of expr * expr
  | Add of expr * expr
  | Mul of expr * expr
type lin_eq = int * string * int
type term = int * (string list)

let rec term_cmp term1 term2 =
  let _,vs1 = term1 in
  let _,vs2 = term2 in
  let rec vs_cmp vs1 vs2 =
    match vs1,vs2 with
    | [],[] -> 0
    | _,[] -> 1
    | [],_ -> (-1)
    | h1::_,h2::_ when h1 < h2 -> -1
    | h1::_,h2::_ when h1 > h2 -> 1
    | _::rest1,_::rest2 -> vs_cmp rest1 rest2
  in vs_cmp vs1 vs2
  
let neg_term term1 =
  let a,vs = term1 in
  (-a),vs

let add_terms term1 term2 =
  let a1,vs1 = term1 in
  let a2,vs2 = term2 in
  if (term_cmp term1 term2) <> 0
  then
    failwith "Can only add like terms"
  else
    a1+a2,vs1

let mul_terms term1 term2 =
  let a1,vs1 = term1 in
  let a2,vs2 = term2 in
  a1*a2,List.sort (fun v1 v2 -> String.compare v1 v2) vs1@vs2

let rec solve e =
  match e with
  | Const n -> [n,[]]
  | Var v -> [1,[v]]
  | Sub (e1,e2) ->
      let terms1 = solve e1 in
      let terms2 = solve e2 in
      let rec merge_terms merged terms1 terms2 =
        match terms1, terms2 with
        | [],[] -> merged
        | term1::rest1,[] -> merge_terms (merged @ [term1]) rest1 []
        | [],term2::rest2 -> merge_terms (merged @ [neg_term term2]) [] rest2
        | term1::rest1,term2::_ when (term_cmp term1 term2) = (-1) -> merge_terms (merged @ [term1]) rest1 terms2
        | term1::_,term2::rest2 when (term_cmp term1 term2) = 1 -> merge_terms (merged @ [neg_term term2]) terms1 rest2
        | term1::rest1,term2::rest2 -> 
            merge_terms (merged @ [(add_terms term1 (neg_term term2))]) rest1 rest2
      in merge_terms [] terms1 terms2
  | Add (e1,e2) ->
      let terms1 = solve e1 in
      let terms2 = solve e2 in
      let rec merge_terms merged terms1 terms2 =
        match terms1, terms2 with
        | [],[] -> merged
        | term1::rest1,[] -> merge_terms (merged @ [term1]) rest1 []
        | [],term2::rest2 -> merge_terms (merged @ [term2]) [] rest2
        | term1::rest1,term2::_ when (term_cmp term1 term2) = (-1) -> merge_terms (merged @ [term1]) rest1 terms2
        | term1::_,term2::rest2 when (term_cmp term1 term2) = 1 -> merge_terms (merged @ [term2]) terms1 rest2
        | term1::rest1,term2::rest2 -> 
            merge_terms (merged @ [(add_terms term1 term2)]) rest1 rest2
      in merge_terms [] terms1 terms2
  | Mul (e1,e2) ->
      let terms1 = solve e1 in
      let terms2 = solve e2 in
      let crossed_terms = List.sort
      (fun term1 term2 -> term_cmp term1 term2)
      (List.fold_left
      (fun acc term1 ->
        acc@List.fold_left
        (fun acc' term2 -> acc'@[mul_terms term1 term2])
        [] terms2
      )
      [] terms1) in
      let rec combine_like_terms acc terms =
        match terms with
        | [] -> acc
        | term1::term2::rest when (term_cmp term1 term2) = 0 -> combine_like_terms (acc@[add_terms term1 term2]) rest
        | term1::rest -> combine_like_terms (acc@[term1]) rest
      in combine_like_terms [] crossed_terms

let term_to_string t =
  let a,vs = t in
  let rec combine_vars vs =
    match vs with
    | v::t -> v^(combine_vars t)
    | [] -> ""
  in Printf.sprintf "%d%s" a (combine_vars vs)

let () =
  let e1 = (Sub ((Sub (Var "b", (Add (Mul (Var "s1",Const 1),Add (Mul (Var "s2",Const 3),Mul (Var "s3",Const 4)))))), Const 1)) in
  let e2 = (Sub ((Sub (Var "b", (Add (Mul (Var "s1",Const 3),Add (Mul (Var "s2",Const 7),Mul (Var "s3",Const 2)))))), Const 2)) in
  let e3 = (Mul (e1,e2)) in
  List.iter (Printf.printf "%s\n") (List.map term_to_string (solve e3))
