import numpy as np
grid = np.zeros((1000,1000))
# Change to 1 for part 1
number_of_knots = 9
T, H = [(0,0) for _ in range(number_of_knots)], (0,0)
moves = open("9.in", "r").read().split("\n")

def traverse(T,H,direction, should_move=True):
    moved_vert = lambda: abs(H[1]-T[1]) >= 2
    moved_hori = lambda: abs(H[0] - T[0]) >= 2
    moved_diag = lambda: abs(H[1]-T[1])+abs(H[0]-T[0]) > 2
    is_t_far_away = lambda: moved_vert() or moved_hori() or moved_diag()
    if should_move:
        match direction:
            case "R":
                if should_move:
                    H = (H[0],H[1]+1) 
            case "L":
                H = (H[0],H[1]-1) 
            case "U":
                H = (H[0]+1,H[1]) 
            case "D":
                H = (H[0]-1,H[1]) 
    if is_t_far_away():
        # Moved up
        if H[0] == T[0] and H[1]-T[1] >= 2:
            T = T[0],T[1]+1
        elif H[0] == T[0] and T[1]-H[1] >= 2:
            T = T[0],T[1]-1
        elif H[1] == T[1] and H[0]-T[0] >= 2:
            T = T[0]+1,T[1]
        elif H[1] == T[1] and T[0]-H[0] >= 2:
            T = T[0]-1,T[1]
        elif moved_diag() and H[0] - T[0] >= 1 and H[1] - T[1] >= 1:
            T = T[0]+1,T[1]+1
        elif moved_diag() and H[0] - T[0] >= 1 and T[1] - H[1] >= 1:
            T = T[0]+1,T[1]-1
        elif moved_diag() and T[0] - H[0] >= 1 and H[1] - T[1] >= 1:
            T = T[0]-1,T[1]+1
        else:
            T = T[0]-1,T[1]-1
    return T,H

for move in moves:
    direction, occurences = move.split(" ")
    occurences = int(occurences)
    for _ in range(occurences):
        for i in range(number_of_knots):
            if i == 0:
                T[i],H = traverse(T[i], H, direction)
            else:
                T[i],_ = traverse(T[i],T[i-1], direction, should_move=False)
        grid[T[-1]] = 1
print(sum(grid.flatten()))