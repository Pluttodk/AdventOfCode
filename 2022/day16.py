import networkx as nx

valves = open("16.in","r").read().split("\n")

G = nx.DiGraph()

for valve in valves:
# Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    f, t = valve.split(";")
    flow = int(f.split("=")[1])
    f = f.split(" ")[1]
    t = t.split(", ")

    graph[f] = Valve(flow, f, set())
    for ti in t:
        if len(ti) > 2:
            ti = ti[-2:]
        graph[f].routes.add(ti)

def bfs_part1(node, total_flow, minutes):
    if not minutes:
        return total_flow
    elif len(node.routes):
        return max([
            bfs_part1(graph[pred], total_flow*2, minutes-1)
            for pred in node.routes
        ])
    else:
        return total_flow*(30-minutes)
print(bfs_part1(graph["AA"], 0, 30))