import numpy as np
vals = list(map(int, open("data/day1.txt").readlines()))
print(len(list(filter(lambda x:x[0]<x[1],list(zip(*(vals[:-1],vals[1:])))))))

print(len(list(filter(lambda i: sum(vals[i-2:i+1]) > sum(vals[i-3:i]), list(range(3,len(vals)))))))
