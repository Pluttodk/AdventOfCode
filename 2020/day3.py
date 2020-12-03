import numpy as np
area = np.zeros((323,31))
with open("2020/data/day3.txt") as file:
    lines = file.readlines()
    for i,line in enumerate(lines):
        info = list(map(lambda x: 0 if x == "." else 1, line.strip()))
        area[i] = info

def check_slope(right,down):
    right_pos = 0
    trees = 0
    for i, cut in enumerate(area[down:]):
        if not i % down:
            right_pos += right
            trees += cut[right_pos % len(cut)]
    return trees

def part1():
    return check_slope(3,1)
print(part1())
def part2():
    routes = [(1,1),(3,1),(5,1),(7,1),(1,2)]
    trees = 1
    for r,d in routes:
        trees *= check_slope(r,d)
    return trees
print(part2())