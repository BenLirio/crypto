package main

import (
  "crypto/rand"
  "fmt"
)

func l(a int) int {
  return 3*a
}

func G(k []byte) []byte {
  n := l(len(k))
  r := make([]byte, n)
  rand.Read(r)
  return r
}

func main() {
  n := 3
  s := make([]byte, n)
  a := G(s)
  fmt.Println(a)
}
