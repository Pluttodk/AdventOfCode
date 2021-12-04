import numpy as np
lines = open("data/day4.txt").readlines()

numbers = list(map(int, lines[0].split(",")))

boards = []
for i in range(2,len(lines), 6):
    b = []
    for l in lines[i:i+5]:
        v = l.strip().split(" ")
        b.append(list(map(int, filter(lambda x: x != "", v))))
    boards.append(b)

def check(board, vals, f=lambda x,i:x[i,:]):
    for i in range(5):
        row = f(board,i)
        match = [v in row for v in vals]
        if len(list(filter(lambda x: x, match))) >= 5:
            return True, row
    return False,[]

def part1(boards, start=5):
    boards = np.array(boards)
    stop = False
    result = None
    for j in range(start,len(numbers)):
        focus_vals = numbers[:j]
        for k, b in enumerate(boards):
            result1 = check(b, focus_vals) 
            result2 = check(b, focus_vals, lambda x,i: x[:,i])
            if result1[0] or result2[0]:
                result = (result, k, b)
                stop = True
                break
        if stop:
            break

    # Part 1
    return sum([0 if x in focus_vals else x for x in result[-1].flatten()]) * focus_vals[-1], focus_vals, result[-2]
print(part1(boards))

# Part 2
boards = [np.array(b) for b in boards]
stop = False
result = None
siz = len(boards)
start = 5
while len(boards):
    result = part1(boards, start)
    start = len(result[-2])
    boards.pop(result[-1])
    print(f"\r {len(boards)}/{siz}", end="\r")
print(result)
