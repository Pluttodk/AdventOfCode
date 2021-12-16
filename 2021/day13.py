import numpy as np


board, folds = [],[]
for line in open("data/day13.txt"):
    line = line.strip()
    if line.startswith("fold"):
        folds.append(line.split(" ")[-1])
    elif line != "":
        board.append(list(map(int, line.split(","))))

max_x, max_y = max(board, key=lambda x: x[0]), max(board, key=lambda x: x[1])

paper = np.zeros((max_x[0]+1,max_y[1]+1))
for x,y in board:
    paper[x,y] += 1

for i, fold in enumerate(folds):
    direction, val = fold.split("=")
    val = int(val)
    if direction == "x":
        # Fold up
        lower_part = paper[val+1:]
        paper[val-lower_part.shape[0]:val] += np.flip(paper[val+1:],axis=0)
        paper = paper[:val]
    else:
        lower_part = paper[:,val+1:]
        paper[:,val-lower_part.shape[1]:val] += np.flip(paper[:,val+1:], axis=1)
        paper = paper[:,:val]
    if i == 0:
        print("Part 1: ", len(paper.flatten()[paper.flatten()>0]))

# Print it such that I can read it :P
format_paper = [""]*len(paper[0])
for pap in paper:
    for i, p in enumerate(pap):
        format_paper[i] += "#" if p else "."
print("\n".join(format_paper))