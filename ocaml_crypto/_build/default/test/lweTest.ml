open Lwe

type assertion = unit -> unit

let assert_eqf : ('a -> 'b) -> 'b -> assertion =
  fun f v -> (fun () -> if f () <> v then failwith "not_equal" else ())

type test = string * assertion

let run_test : test -> unit =
  fun t ->
    let name, af = t in
    Printf.printf "Testing %s..." name;
    try
      af (); Printf.printf "passed\n"
    with
    | _ -> Printf.printf "failed"


let add_tests = [
  ("add_0", assert_eqf
    (fun () -> add (4L,8L) (3L,8L)) (7L,8L)
  );
  ("add_1", assert_eqf
    (fun () -> add (4L,7L) (6L,7L)) (3L,7L)
  );
  ("add_3", assert_eqf
    (fun () ->
      try
        ignore @@ add (0L,1L) (0L,2L); true
      with
      | _ -> false
    ) false
  );
]

let mul_tests = [
  ("mul_0", assert_eqf
    (fun () -> mul (4L,8L) (3L,8L)) (4L,8L)
  );
  ("mul_1", assert_eqf
    (fun () -> mul (4L,7L) (1L,7L)) (4L,7L)
  );
  ("mul_3", assert_eqf
    (fun () ->
      try
        ignore @@ mul (0L,1L) (0L,2L); true
      with
      | _ -> false
    ) false
  );
]

let tests = add_tests@mul_tests

let () =
  List.iter run_test tests
