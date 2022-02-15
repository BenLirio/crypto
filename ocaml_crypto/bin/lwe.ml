type modulo = int64
type num = int64*modulo

let add n1 n2 =
  let open Int64 in
  match (n1, n2) with
  | (_,q1),(_,q2) when q1 <> q2 -> failwith "Must be same modulo"
  | (n1,q),(n2,_) -> (rem (add n1 n2) q, q)

let mul n1 n2 =
  let open Int64 in
  match (n1, n2) with
  | (_,q1),(_,q2) when q1 <> q2 -> failwith "Must be same modulo"
  | (n1,q),(n2,_) -> (rem (mul n1 n2) q, q)

let rand_num modulo =
  (Random.int64 modulo, modulo)

type vec = int * num list

let dot v1 v2 =
  match v1,v2 with
  | (_,ns1), (_,ns2) -> List.fold_left2 (fun acc a b -> mul a b |> add acc) ns1 ns2

let uniform_vec n modulo = 
  (n, List.map rand_num (List.init n (fun _ -> modulo)))

