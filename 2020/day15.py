inp = list(map(int, "13,0,10,12,1,5,8".split(",")))

saying = inp[0]
vals = {}
stop = 30_000_000
for turn in range(0, stop):
    if turn < len(inp):
        saying = inp[turn]
    if turn == stop - 1:
        print(saying, turn)
    if saying in vals:
        res = turn-vals[saying]
        vals[saying] = turn
        saying = res
    else:
        vals[saying] = turn
        saying = 0
