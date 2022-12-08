import numpy as np
vals = np.array(list(map(list, open("8.in", "r").read().split("\n"))))
width, height = vals.shape

def check_val(i,j):
    # Inside forrest
    if 1 <= i < width-1 and 1 <= j < height-1:
        way_to_check = [
            max(vals[0:i,j]) < vals[i,j],
            max(vals[i+1:height,j]) < vals[i,j],
            max(vals[i,0:j]) < vals[i,j],
            max(vals[i,j+1:width]) < vals[i,j]
        ]
        return any(way_to_check)
    else:
        return True

def scenic_score(i,j):
    answer = list(np.where(vals[0:i,j][::-1] >= vals[i,j])[0])
    pos_up = len(vals[0:i,j][::-1]) if not len(answer) else min(answer)+1

    answer = list(np.where(vals[i+1:height,j] >= vals[i,j])[0])
    pos_down = len(vals[i+1:height,j]) if not len(answer) else min(answer)+1

    answer = list(np.where(vals[i,0:j][::-1] >= vals[i,j])[0])
    pos_left = len(vals[i,0:j]) if not len(answer) else min(answer)+1

    answer = list(np.where(vals[i,j+1:width] >= vals[i,j])[0])
    pos_right = len(vals[i,j+1:width]) if not len(answer) else min(answer)+1
    return pos_up*pos_down*pos_left*pos_right

result = []
part2 = []
for k in range(width):
    for p in range(height):
        # Part 1
        result.append(check_val(k,p))
        part2.append(scenic_score(k,p))
print(len(list(filter(lambda x: x, result))))
print(max(part2))