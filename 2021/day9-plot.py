import numpy as np
from matplotlib import pyplot as plt

vals = np.array([list(map(int, list(l.strip()))) for l in open("data/day9.txt")])

fig = plt.figure()
ax = plt.axes(projection='3d')
vals = np.array([list(map(int, list(l.strip()))) for l in open("data/day9.txt")])


def check_adjacent(board, i,j):
    is_lowest = True
    siz_x, siz_y = board.shape
    #Check up
    if j+1 < siz_y and board[i,j] >= board[i,j+1]:
        is_lowest = False
    #Check down
    if j-1 >= 0 and board[i,j] >= board[i,j-1]:
        is_lowest = False
    #Check left
    if i+1 < siz_x and board[i,j] >= board[i+1,j]:
        is_lowest = False
    #Check right
    if i-1 >= 0 and board[i,j] >= board[i-1,j]:
        is_lowest = False
    return is_lowest

siz_x, siz_y = vals.shape
risk_level = 0
risk_groups = []
for x in range(siz_x):
    for y in range(siz_y):
        if check_adjacent(vals, x,y):
            risk_level += vals[x,y]+1
            risk_groups.append((x,y))
# Part 1
print(risk_level)
bassins = []
def fire_grass_bassin(board, x,y, bassin=[], seen = {}):
    siz_x, siz_y = board.shape
    #Check up
    if y+1 < siz_y and board[x,y] < board[x,y+1] and board[x,y+1] != 9 and f"{x},{y+1}" not in seen:
        if board[x,y+1] != 9:
            seen[f"{x},{y+1}"] = True
            bassin.append((board[x,y+1],x,y))
            fire_grass_bassin(board, x, y+1,bassin, seen)
    #Check down
    if y-1 >= 0 and board[x,y] < board[x,y-1] and board[x,y-1] != 9 and f"{x},{y-1}" not in seen:
            seen[f"{x},{y-1}"] = True
            bassin.append((board[x,y-1],x,y))
            fire_grass_bassin(board, x, y-1,bassin, seen)
    #Check right
    if x+1 < siz_x and board[x,y] < board[x+1,y] and board[x+1,y] != 9 and f"{x+1},{y}" not in seen:
        seen[f"{x+1},{y}"] = True
        bassin.append((board[x+1,y],x,y))
        fire_grass_bassin(board, x+1, y, bassin, seen)
    # #Check lef
    if x-1 >= 0 and board[x,y] < board[x-1,y] and board[x-1,y] != 9 and f"{x-1},{y}" not in seen:
        seen[f"{x-1},{y}"] = True
        bassin.append((board[x-1,y],x,y))
        fire_grass_bassin(board, x-1, y, bassin, seen)
    return bassin
bassins = [fire_grass_bassin(vals, x,y, [vals[x,y]]) for x,y in risk_groups]
bassins = list(map(lambda x: (len(x),x), bassins))
result = sorted(bassins, reverse=True, key=lambda x: x[0])[:3]

x_data = np.arange(len(vals[0]))
y_data = np.arange(len(vals[1]))
for bassin in result:
    print(bassin)
    indeks = {f"{b[1]},{b[2]}":vals[b[1],b[2]] for b in bassin}
def f(x,y):
    st = f"{x},{y}"
    if st in indeks:
        return indeks[st]
    else:
        return 9
X,Y = np.meshgrid(x_data, y_data)
Z = f(X,Y)

ax.contour3D(X, Y, Z, 50)
plt.show()