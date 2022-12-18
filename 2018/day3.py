values = open("day3test.txt", "r")

gLeft, gRight = 0,0
for line in values:
    values = line.split(":")
    positions = values[1].split("x")
    left, right = int(positions[0]), int(positions[1])
    if(left > gLeft):
        gLeft = left
    if right > gRight:
        gRight = right

Matrix = [[0 for x in range(gLeft+1)] for y in range(gRight+1)]
samePos = 0
values = open("day3test.txt", "r")
print Matrix[5][5]
for line in values:
    re = line.split(",")
    r = int(re[1].split(":")[0])
    l = int(re[0].split(" ")[2])
    print l
    print r
    print gLeft
    print gRight
    if(Matrix[l][r] == 0):
        Matrix[l][r] += 1
    else:
        samePos += 1
print samePos