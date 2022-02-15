class Stream:
    def __init__(self, seed):
        self.seed = seed
        self.vec = 0
    def __next__(self):
        self.vec += 1
        return self.vec

if __name__ == '__main__':
    st = Stream(3)
    x = next(st)
    print(x)
    x = next(st)
    print(x)
