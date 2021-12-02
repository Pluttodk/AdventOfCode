vals = open("data/day2.txt").readlines()

# Part 1
horizontal = 0
vertical = 0
for line in vals:
    value = int(line.split(" ")[1])
    if line.startswith("forward"):
        horizontal += value
    elif line.startswith("up"):
        vertical -= value
    elif line.startswith("down"):
        vertical += value
print(horizontal, vertical, horizontal*vertical)

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
