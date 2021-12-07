import numpy as np
vals = np.array(list(map(int, open("data/day7.txt").readlines()[0].split(","))))

# Part 1
h,l = max(vals), min(vals)
result = [sum(abs(vals-(np.zeros(len(vals))+i))) for i in range(l,h)]
print(min(result))

# Part 2
result = []
for i in range(l,h):
    result.append(sum([sum(list(range(1,abs(val-i)+1))) for val in vals]))
print(min(result))