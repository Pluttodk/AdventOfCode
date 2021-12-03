import numpy as np
vals = open("data/day2.txt").readlines()

# Part 1 as a few oneliners
forward = sum(map(lambda x: int(x[7:]), filter(lambda x: x.startswith("forward"), vals)))
up = sum(map(lambda x: int(x[2:]), filter(lambda x: x.startswith("up"), vals)))
down = sum(map(lambda x: int(x[4:]), filter(lambda x: x.startswith("down"), vals)))
print(forward*(down-up))

# Part 2
horizontal = 0
vertical = 0
aim = 0
for line in vals:
    value = int(line.split(" ")[1])
    if line.startswith("forward"):
        horizontal += value
        vertical += aim*value
    elif line.startswith("up"):
        aim -= value
    elif line.startswith("down"):
        aim += value
print(horizontal, vertical, horizontal*vertical)
