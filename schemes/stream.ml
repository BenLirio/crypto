type next = state -> (int * state)
type init = seed -> state
type stream = init * next
