package main

import (
  "fmt"
)

type Lattice [][]int
func (lat Lattice) Det() int {
}

func main() {
  n := 2
  lat := make(Lattice, n)
  lat[0] = []int{1,0}
  lat[1] = []int{1,0}
  fmt.Println(lat)
}
