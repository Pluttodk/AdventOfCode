import sys

line1, line2 = sys.stdin.readlines()[:2]

def manhatten_dist(p1, p2):
    x1,y1 = p1
    x2,y2 = p2
    if (p2 != (0,0)):
        return abs(x2-x1)+abs(y2-y1)
    else:
        return float("inf")

def trace(line):
    vectors = [(l[:1],int(l[1:])) for l in line.split(",")]
    path = [(0,0)]
    mv_dict = {"U": (0,1), "D": (0,-1), "L": (-1,0), "R": (1,0)}
    for v in vectors:
        mv, trace = v
        direction = mv_dict[mv]
        start = path[-1]
        for pos in range(1, trace+1):
            path.append((start[0]+direction[0]*pos, start[1]+direction[1]*pos))
    return path

mv1 = trace(line1)
mv2 = trace(line2)

same = list(set(mv1) & set(mv2))

# ------EX 1 ------
# res = [manhatten_dist((0,0), p) for p in same]
# print(min(res))

# -------EX 2 -------
steps_sum = []
for p in same:
    s1 = mv1.index(p)
    s2 = mv2.index(p)
    steps_sum.append(s1+s2)
steps_sum.remove(0)
print(min(steps_sum))

