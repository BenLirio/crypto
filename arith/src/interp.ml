open Ast
open Ds


let q = 7
let set x = x mod q
let (+) a b = a + b |> set
let ( * ) a b = a * b |> set




exception Invalid_Normal_Expression
let rec check_normal_expr : expr -> unit = fun e ->

  match e with
  | NormTerm -> ()
  | NormElem (((_,vg1),_),NormElem (((_,vg2),_),_)) when cmp_var_grp vg1 vg2 <> -1 -> raise Invalid_Normal_Expression
  | NormElem (((_,_),_),next) -> check_normal_expr next
  | _ -> raise Invalid_Normal_Expression


let rec optimize : expr -> expr =
  fun e ->
    match e with
    | Var s -> NormElem(((1,[s]),0),NormTerm)
    | Int n -> Int n
    | Add(e1,e2) -> Add(optimize e1, optimize e2)
    | Sub(e1,e2) ->
        let e1' = optimize e1 in
        let e2' = optimize e2 in
        Sub(e1', e2')
    | Mul(e1,e2) -> Mul(optimize e1, optimize e2)
    | _ -> failwith "Not implemented yet!"


(** [eval_expr e] evaluates expression [e] *)
let rec eval_expr : expr -> int result =
  fun e ->
  match e with
  | Var _ -> return 0
  | Int n      -> set n |> return
  | Add(e1,e2) ->
    eval_expr e1 >>= fun n ->
    eval_expr e2 >>= fun m ->
    return (n+m)
  | Sub(e1,e2) ->
    eval_expr e1 >>= fun n ->
    eval_expr e2 >>= fun m ->
    return (n-m)   
  | Mul(e1,e2) ->
    eval_expr e1 >>= fun n ->
    eval_expr e2 >>= fun m ->
    return (n*m)   
  | _ -> failwith "Not implemented yet!"


(** [parse s] parses string [s] into an ast *)
let parse (s:string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(** [interp s] parses [s] and then evaluates it *)
let interp (e:string) : int result =
  let e_optimization = e |> parse |> optimize in
  Printf.printf "%s\n" (pretty_string_of_expr e_optimization);
  eval_expr e_optimization



