import numpy as np
import networkx as nx

locations = np.array(list(map(lambda x: list(map(ord, x)), open("12.in","r").read().split("\n"))))
#Capital letters are those smaller than or equal 96
start, end = 83, 69
vals = {
    start: ord("a"),
    end: ord("z")
}
height, width = locations.shape

graph = nx.DiGraph()
for y in range(height):
    for x in range(width):
        directions = [(0,1),(0,-1),(1,0),(-1,0)]
        cur = locations[y,x]
        for y1,x1 in directions:
            if 0 <= y+y1 < height and 0 <= x+x1 < width:
                next_loc = locations[y+y1,x+x1]
                if cur in vals:
                    cur = vals[cur]
                if next_loc in vals:
                    next_loc = vals[next_loc]
                if cur+1 >= next_loc:
                    graph.add_edge(f"{y}_{x}", f"{y+y1}_{x+x1}")

# Part1
start_node = list(zip(*np.where(locations == start)))[0]
end_node = list(zip(*np.where(locations == end)))[0]
print(len(nx.shortest_path(graph, f"{start_node[0]}_{start_node[1]}", f"{end_node[0]}_{end_node[1]}"))-1)

# Plotting the shortest_path
from matplotlib import pyplot as plt
from networkx.drawing.nx_pydot import graphviz_layout
sub_graph = nx.subgraph(graph, nx.shortest_path(graph, f"{start_node[0]}_{start_node[1]}", f"{end_node[0]}_{end_node[1]}"))
pos = nx.nx_agraph.pygraphviz_layout(sub_graph, "dot")
nx.draw(sub_graph, pos)
plt.show()


# Part 2
shortest_route = []
start_node = list(zip(*np.where(locations == start)))
start_node += list(zip(*np.where(locations == ord("a"))))
for s in start_node:
    try:
        shortest_route.append(
            len(nx.shortest_path(graph, f"{s[0]}_{s[1]}", f"{end_node[0]}_{end_node[1]}"))-1
        )
    except:
        continue
print(sorted(shortest_route)[0])
