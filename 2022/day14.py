import numpy as np
cave = np.zeros((200,10000))

rocks = open("14.in","r").read().split("\n")

ys = []
x = []
for rock in rocks:
    path = rock.split(" -> ")
    for fr, to in zip(path[:-1], path[1:]):
        fx,fy = map(int, fr.split(","))
        tx,ty = map(int, to.split(","))

        yf, yt = min(fy,ty), max(fy,ty)
        xf, xt = min(fx,tx), max(fx,tx)
        ys.append(yt)
        x += [fx,tx]
        cave[yf:yt+1,xf:xt+1] = 1

# Remove following line for part 1
cave[max(ys)+2,:] = 1
###################################

round = 0
while True:
    round+=1
    try:
        #Drop sand
        sand_pos = (0,500)
        while cave[sand_pos[0]+1,sand_pos[1]] == 0 or cave[sand_pos[0]+1,sand_pos[1]-1] == 0 or cave[sand_pos[0]+1,sand_pos[1]+1] == 0:
            if cave[sand_pos[0]+1,sand_pos[1]] == 0:
                sand_pos = (sand_pos[0]+1, sand_pos[1])
            elif cave[sand_pos[0]+1,sand_pos[1]-1] == 0:
                sand_pos = (sand_pos[0]+1, sand_pos[1]-1)
            else:
                sand_pos = (sand_pos[0]+1, sand_pos[1]+1)
        if sand_pos == (0,500):
            print(round)
            break
        cave[sand_pos] = 2
    except:
        print(round-1)
        break