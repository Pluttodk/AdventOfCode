import numpy as np
lines = open("data/day5.txt").readlines()

values = np.array([list(map(int, ",".join(l.split(" -> ")).split(","))) for l in lines])

siz_x = max([max(values[:,0]), max(values[:,2])])+1
siz_y = max([max(values[:,1]), max(values[:,3])])+1

# Part 1
floor = np.zeros((siz_x,siz_y))
for x1,y1,x2,y2 in values:
    x1,x2 = (x1,x2) if x1 <= x2 else (x2,x1)
    y1,y2 = (y1,y2) if y1 <= y2 else (y2,y1)
    if x1 == x2 or y1 == y2:
        for i in range(x1,x2+1):
            for j in range(y1,y2+1):
                floor[j,i]+=1
result = floor.flatten()
print(len(result[result >= 2]))

# Part 2
floor = np.zeros((siz_x,siz_y))
for x1,y1,x2,y2 in values:
    if x1 == x2 or y1 == y2:
        x1,x2 = (x1,x2) if x1 <= x2 else (x2,x1)
        y1,y2 = (y1,y2) if y1 <= y2 else (y2,y1)
        for i in range(x1,x2+1):
            for j in range(y1,y2+1):
                floor[j,i]+=1
    else:
        xt1,xt2 = (x1,x2) if x1 <= x2 else (x2,x1)
        yt1,yt2 = (y1,y2) if y1 <= y2 else (y2,y1)
        xs = list(range(xt1,xt2+1))
        if x1 > x2:
            xs = xs[::-1]
        ys = list(range(yt1,yt2+1))
        if y1 > y2:
            ys = ys[::-1]
        for x,y in zip(xs,ys):
            floor[y,x]+=1
result = floor.flatten()
print(len(result[result >= 2]))