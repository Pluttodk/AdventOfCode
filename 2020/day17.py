import copy
import numpy as np
#Part 1
grid = np.array(list(map(list, open("2020/data/day17.txt").read().split("\n")))).reshape((1,8,8))
new_grid = np.zeros((grid.shape[0]+2, grid.shape[1]+2, grid.shape[2]+2))
for z in range(grid.shape[0]):
    for y in range(grid.shape[1]):
        for x in range(grid.shape[2]):
            if grid[z,y,x] == "#":
                new_grid[z+1,y+1,x+1] = 1
grid = new_grid
x,y,z = 0,0,0

def neighbors(grid, x, y, z):
    actives = 0
    x_low = x-1 if x-1 >= 0 else 0
    x_high = x+2 if x+2 < grid.shape[2] else grid.shape[2]

    y_low = y-1 if y-1 >= 0 else 0
    y_high = y+2 if y+2 < grid.shape[1] else grid.shape[1]
    
    z_low = z-1 if z-1 >= 0 else 0
    z_high = z+2 if z+2 < grid.shape[0] else grid.shape[0]
    for x_i in range(x_low, x_high):
        for y_i in range(y_low, y_high):
            for z_i in range(z_low, z_high):
                if x_i == x and y_i == y and z_i == z:
                    continue
                actives += grid[z_i,y_i,x_i]
    return actives

for rounds in range(6):
    depth, width, height = grid.shape
    new_grid = np.zeros((depth+2, width+2, height+2))
    new_vals = []
    for z in range(depth):
        for y in range(width):
            for x in range(height):
                active_neighbors = neighbors(grid, x,y,z)
                if 2 <= active_neighbors <= 3 and grid[z,y,x] == 1:
                    new_vals.append((z+1,y+1,x+1,1))
                elif active_neighbors == 3 and grid[z,y,x] == 0:
                    new_vals.append((z+1,y+1,x+1,1))
                else:
                    new_vals.append((z+1,y+1,x+1,0))
    for z,y,x,val in new_vals:
        new_grid[z,y,x] = val
    grid = new_grid
    # print(grid)
print(new_grid.sum(-1).sum(-1).sum(-1))


#Part 2
grid = np.array(list(map(list, open("2020/data/day17.txt").read().split("\n")))).reshape((1,1,8,8))
new_grid = np.zeros((grid.shape[0]+2, grid.shape[1]+2, grid.shape[2]+2, grid.shape[3]+2))
for z in range(grid.shape[0]):
    for y in range(grid.shape[1]):
        for x in range(grid.shape[2]):
            for w in range(grid.shape[3]):
                if grid[z,y,x,w] == "#":
                    new_grid[z+1,y+1,x+1,w+1] = 1
grid = new_grid
x,y,z,w = 0,0,0,0

def neighbors_part2(grid, x, y, z,w):
    actives = 0
    x_low = x-1 if x-1 >= 0 else 0
    x_high = x+2 if x+2 < grid.shape[2] else grid.shape[2]

    y_low = y-1 if y-1 >= 0 else 0
    y_high = y+2 if y+2 < grid.shape[1] else grid.shape[1]
    
    z_low = z-1 if z-1 >= 0 else 0
    z_high = z+2 if z+2 < grid.shape[0] else grid.shape[0]

    w_low = w-1 if w-1 >= 0 else 0
    w_high = w+2 if w+2 < grid.shape[3] else grid.shape[3]
    for x_i in range(x_low, x_high):
        for y_i in range(y_low, y_high):
            for z_i in range(z_low, z_high):
                for w_i in range(w_low, w_high):
                    if x_i == x and y_i == y and z_i == z and w_i == w:
                        continue
                    actives += grid[z_i,y_i,x_i,w_i]
    return actives

for rounds in range(6):
    depth, width, height, time = grid.shape
    new_grid = np.zeros((depth+2, width+2, height+2,time+2))
    new_vals = []
    for z in range(depth):
        for y in range(width):
            for x in range(height):
                for w in range(time):
                    active_neighbors = neighbors_part2(grid, x,y,z,w)
                    if 2 <= active_neighbors <= 3 and grid[z,y,x,w] == 1:
                        new_vals.append((z+1,y+1,x+1,w+1,1))
                    elif active_neighbors == 3 and grid[z,y,x,w] == 0:
                        new_vals.append((z+1,y+1,x+1,w+1,1))
                    else:
                        new_vals.append((z+1,y+1,x+1,w+1,0))
    for z,y,x,w,val in new_vals:
        new_grid[z,y,x,w] = val
    grid = new_grid
    # print(grid)
print(new_grid.sum(-1).sum(-1).sum(-1).sum(-1))