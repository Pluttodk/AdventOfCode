data = open("2020/data/day9.txt").read().split("\n")
data = list(map(int, data))


def is_valid(preamble,value):
    for v in preamble:
        for v2 in preamble:
            if v != v2 and v+v2 == value:
                return True
    return False

#Part 1
for i,val in enumerate(data[25:]):
    preamble = data[i:i+25]
    valid = is_valid(preamble, val)
    if not valid:
        print(val)
        goal = val

#Part 2
for i in range(len(data)):
    for j in range(i,len(data)):
        if sum(data[i:j]) == goal:
            results = sorted(data[i:j])
            print(results[0]+results[-1])