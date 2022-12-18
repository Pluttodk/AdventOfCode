#Djikstra (You know the drill)
import numpy as np

vals = np.array([list(map(int, l.strip())) for l in open("data/day15.txt")])

high_x,high_y = vals.shape
part2_vals = np.zeros((high_x*5, high_y*5))
part2_vals[:high_x,:high_y] = vals
for xi, x in enumerate(range(0,high_x*5, high_x)):
    for yi, y in enumerate(range(0,high_y*5, high_y)):
        multi = xi+yi
        part2_vals[x:x+high_x,y:y+high_y] = vals+multi
part2_vals[part2_vals > 9] = part2_vals[part2_vals > 9] % 9

# Uncomment below line for part 1
vals = part2_vals

start = (0,0)
loc = start
goal = len(vals), len(vals[0])
adj = {}
for x in range(goal[0]):
    for y in range(goal[1]):
        neighbors = []
        if x-1 >= 0:
           neighbors.append((x-1,y,False))
        if x+1 < goal[0]:
           neighbors.append((x+1,y,False))
        if y+1 < goal[1]:
           neighbors.append((x,y+1,False))
        if y-1 >= 0:
           neighbors.append((x,y-1,False))
        adj[f"{x}-{y}"] = neighbors

D = {w:np.inf for w in adj.keys()}
D["0-0"] = 0
pq = [(0, "0-0")]
visited = []
while pq != []:
    pq = sorted(pq, key=lambda x: x[0])
    (dist, current_vertex) = pq[0]
    pq = pq[1:]
    visited.append(current_vertex)
    for i, (x,y,v) in enumerate(adj[current_vertex]):
        if f"{x}-{y}" not in visited:
            distance = vals[x,y]
            name = f"{x}-{y}"
            old_cost = D[name]
            new_cost = D[current_vertex]+distance
            if new_cost < old_cost:
                pq.append((new_cost, name))
                D[name] = new_cost
print("Part 1: ", D[f"{len(vals)-1}-{len(vals[0])-1}"])dd