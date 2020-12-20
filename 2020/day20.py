# This was by far the worst programming exercise. Not really involving any algorithm
# Got some help from: https://github.com/msullivan/advent-of-code/blob/master/2020/20b.py

import numpy as np
from collections import defaultdict
import operator
import math
import functools

data = open("2020/data/day20.txt").read().split("\n\n")

def rotate(line):
    xs = []
    for i in range(len(line)):
        s = ''.join(x[i] for x in line)
        xs.append(s)

    return tuple(reversed(xs))

def redge(line):
    return "".join(l[-1] for l in line)

def ledge(line):
    return "".join(l[0] for l in line)

def edges(line):
    return [line[0], line[-1], ledge(line), redge(line)]

def all_edges(line):
    es = edges(line)
    return es + ["".join(reversed(e)) for e in es]

def flip(line):
    return tuple(reversed(line))

def moves(line):
    for _ in range(4):
        yield line
        yield flip(line)
        line = rotate(line)

edges_to_ID = defaultdict(list)
image_map = {}
for image in data:
    image = image.split("\n")
    n = int(image[0].replace("Tile ", "")[:-1])
    image_map[n] = flip(image[1:])
    for e in all_edges(flip(image[1:])):
        edges_to_ID[e].append(n)

corners = []
for n, tile in image_map.items():
    cnt = 0
    for e in edges(tile):
        cnt += len(edges_to_ID[e]) - 1
    if cnt == 2:
        corners.append(n)

#Part 1
print(functools.reduce(operator.mul, corners))

corner_n = corners[0]
ltile = image_map[corner_n]
while len(edges_to_ID[ledge(ltile)]) == 2:
    ltile = rotate(ltile)

def pick(ln, lgrid, edges_to_ID, image_map):
    re = redge(lgrid)
    me = [x for x in edges_to_ID[re] if x != ln][0]
    mtile = image_map[me]
    for mtile in moves(mtile):
        if re == ledge(mtile):
            break
    return me, mtile
N = int(math.sqrt(len(image_map)))
mgrid = [[None] * N for x in range(N)]
mgrid[0][0] = corner_n, ltile
for y in range(0, N):
    if y > 0:
        ln, lgrid = mgrid[y-1][0]
        me, mtile = pick(ln, flip(rotate(lgrid)), edges_to_ID, image_map)
        mgrid[y][0] = (me, flip(rotate(mtile)))

    for x in range(1, N):
        ln, lgrid = mgrid[y][x-1]
        mgrid[y][x] = pick(ln, lgrid, edges_to_ID, image_map)

ngrid = [[None] * N for x in range(N)]
for i, row in enumerate(mgrid):
    for j, (_, col) in enumerate(row):
        x = list(col[1:-1])
        for k in range(len(x)):
            x[k] = x[k][1:-1]
        ngrid[i][j] = x

pic = []
for i, row in enumerate(ngrid):
    for i2 in range(len(row[0])):
        s = ''
        for j, col in enumerate(ngrid[i]):
            s += col[i2]
        pic.append(s)

MONSTER = """\
                  #
#    ##    ##    ###
 #  #  #  #  #  #   """.split('\n')

#Now pic is one big image
for pic in moves(pic):
    cnt = 0
    for y in range(len(pic)-len(MONSTER)):
        for x in range(len(pic)-len(MONSTER[0])):
            match = True
            for y0 in range(len(MONSTER)):
                for x0 in range(len(MONSTER[y0])):
                    if MONSTER[y0][x0] == '#' and pic[y+y0][x+x0] != '#':
                        match = False
                        break
                if not match:
                    break

            if match:
                cnt += 1

    if cnt:
        break
everything = ''.join(pic).count('#')
monster = ''.join(MONSTER).count('#')
print(everything - monster*cnt)