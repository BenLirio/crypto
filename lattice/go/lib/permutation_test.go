package permutation

import (
  "testing"
  "fmt"
)

func TestHello(_ *testing.T) {
  fmt.Println("Testing...")
}

func TestPermutation(t *testing.T) {
  var ok bool
  p := NewPermutation(3)
  fmt.Println(p.View())
  for {
    p, ok = p.Next()
    if !ok { break }
    fmt.Println(p.View())
  }
}
