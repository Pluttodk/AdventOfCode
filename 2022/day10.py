import numpy as np
CRT = np.zeros((6,40))
actions = open("10.in").read().split("\n")

total_cycles = 1
value = 1
part1 = 0
sprite = (0,3)
for action in actions:
    if action.startswith("addx"):
        cycles = 2
        increase_with = int(action.split(" ")[1])
    else:
        cycles = 1
        increase_with = 0
    for _ in range(cycles):
        if sprite[0] <= (total_cycles%40)-1 < sprite[1]:
            y,x = total_cycles//40, (total_cycles%40)-1
            CRT[y,x] = 1
        if total_cycles in (20,60,100,140,180,220):
            part1 += value*total_cycles
        total_cycles+=1
    value += increase_with
    sprite = (value-1, value+2)
print(part1)
for i in range(6):
    print("".join(list(map(lambda x: "#" if x > 0 else ".", CRT[i]))))