(* The type of the abstract syntax tree (AST). *)

type var_grp = string list
let cmp_var_grp : var_grp -> var_grp -> int = fun vg1 vg2 ->
  if (List.length vg1) <> (List.length vg2)
  then
    Int.compare (List.length vg1) (List.length vg2)
  else
    List.fold_left2 (fun ok v1 v2 -> if ok = 0 then String.compare v1 v2 else ok) 0 vg1 vg2
type lin_expr = (int * var_grp) * int

type expr =
  | NormTerm
  | NormElem of lin_expr * expr
  | Var of string
  | Int of int
  | Add of expr*expr
  | Sub of expr*expr
  | Mul of expr*expr
  | Div of expr*expr
  | Let of string*expr*expr
  | Proc of string*expr
  | App of expr*expr
  | IsZero of expr
  | ITE of expr*expr*expr
  | Debug of expr
  | Letrec of string*string*expr*expr
  | Set of string*expr
  | BeginEnd of expr list
  | NewRef of expr
  | DeRef of expr
  | SetRef of expr*expr
  | Pair of expr*expr
  | Fst of expr
  | Snd of expr
  | Not of expr
  | Abs of expr


let rec string_of_expr e =
  match e with
  | Var s -> "Var "^s
  | Int n -> "Int "^string_of_int n
  | Abs e -> "Abs "^string_of_expr e
  | Add(e1,e2) -> "Add(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Sub(e1,e2) -> "Sub(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Mul(e1,e2) -> "Mul(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Div(e1,e2) -> "Div(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Debug(e) -> "Debug(" ^ (string_of_expr e) ^ ")"
  | NewRef(e) -> "NewRef(" ^ (string_of_expr e) ^ ")"
  | DeRef(e) -> "DeRef(" ^ (string_of_expr e) ^ ")"
  | SetRef(e1,e2) -> "SetRef(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Let(x,def,body) -> "Let("^x^","^string_of_expr def ^","^ string_of_expr body ^")"
  | Proc(x,body) -> "Proc("^x^"," ^ string_of_expr body ^")"
  | App(e1,e2) -> "App("^string_of_expr e1 ^"," ^ string_of_expr e2^")"
  | IsZero(e) -> "Zero?("^string_of_expr e ^")"
  | ITE(e1,e2,e3) -> "IfThenElse("^string_of_expr e1^"," ^ string_of_expr e2^"," ^ string_of_expr e3  ^")"
  | Letrec(x,param,def,body) -> "Letrec("^x^","^ param ^","^ string_of_expr def ^","^ string_of_expr body ^")"
  | Set(x,rhs) -> "Set("^x^","^string_of_expr rhs^")"
  | BeginEnd(es) -> "BeginEnd(" ^ String.concat "," (List.map string_of_expr es) ^")"
  | Pair(e1,e2) -> "Pair("^string_of_expr e1^","^string_of_expr e2^")"
  | Fst(e) -> "Fst("^string_of_expr e^")"
  | Snd(e) -> "Snd("^string_of_expr e^")"
  | Not(e) -> "Not("^string_of_expr e^")"
  | _ -> ""

let rec pretty_string_of_expr e =
  match e with
  | Var s -> s
  | Int n -> Printf.sprintf "%d" n
  | Add(e1,e2) -> (pretty_string_of_expr e1) ^ "+" ^ pretty_string_of_expr e2
  | Sub(e1,e2) -> (pretty_string_of_expr e1) ^ "-" ^ pretty_string_of_expr e2
  | Mul(e1,e2) -> (pretty_string_of_expr e1) ^ "*" ^ pretty_string_of_expr e2
  | Div(e1,e2) -> (pretty_string_of_expr e1) ^ "/" ^ pretty_string_of_expr e2
  | _ -> failwith "Not implemented yet"
