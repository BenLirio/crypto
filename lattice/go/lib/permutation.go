package permutation


type Permutation struct {
  a []int
}

func (p Permutation) cpy() Permutation {
  pNew := Permutation{
    a: make([]int, len(p.a)),
  }
  copy(pNew.a, p.a)
  return pNew
}

func (p Permutation) View() []int {
  view := make([]int, len(p.a)-1)
  copy(view, p.a[1:len(p.a)-1])
  return view
}

func NewPermutation(n int) Permutation {
  p := Permutation{
    a: make([]int, n+1),
  }
  for i := 1; i < len(p.a); i++ {
    p.a[i] = i-1
  }
  return p
}

func (p Permutation) Get(n int) int {
  if n < 0 || n >= len(p.a) {
    panic("Out of bounds")
  }
  return p.a[n+1]
}

func (p Permutation) Next() (Permutation, bool) {
  pNew := p.cpy()
  n := len(pNew.a) - 1
  j := n - 1
  for pNew.a[j] >= pNew.a[j+1] {
    j -= 1
    if j == 0 {
      return Permutation{}, false
    }
  }
  l := n
  for pNew.a[j] >= pNew.a[l] {
    l -= 1
  }
  pNew.a[j], pNew.a[l] = pNew.a[l], pNew.a[j]
  k := j + 1
  l = n
  for k < l {
    pNew.a[k], pNew.a[l] = pNew.a[l], pNew.a[k]
    k += 1
    l -= 1
  }
  return pNew, true
}
