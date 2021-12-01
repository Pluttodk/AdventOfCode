import numpy as np
vals = list(map(int, open("day1.txt").readlines()))
print(len(list(filter(lambda x:x[0]<x[1],list(zip(*(vals[:-1],vals[1:])))))))
#                     )
#                 )
#             )
#         )
#     )
# )
"""
# Part one
vals = []

prev = None
for line in open("day1.txt", "r").readlines():
    if prev is not None and int(line) > prev:
        vals.append(int(line))
    prev = int(line)
print(len(vals))
"""

print(len(list(filter(lambda i: sum(vals[i-2:i+1]) > sum(vals[i-3:i]), list(range(3,len(vals)))))))
# Part two
# res = 0
# for i in range(3, len(vals)):
#     if sum(vals[i-2:i+1]) > sum(vals[i-3:i]):
#         res += 1
# print(res)