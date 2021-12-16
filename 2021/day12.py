from os import read
import numpy as np
paths = {}

for line in open("data/day12.txt"):
    start, end = line.strip().split("-")
    if start in paths:
        paths[start].append(end)
    else:
        paths[start] = [end]

    if end in paths:
        paths[end].append(start)
    else:
        paths[end] = [start]

routes = []
def move(node, route=["start"], has_visited=["start"]):
    if node == "end":
        return route
    res = []
    for way in paths[node]:
        if way not in has_visited:
            new_way = route + [way]
            if way.islower():
                result = move(way, new_way, has_visited+[way])
                if len(result) and result[-1] == "end":
                    routes.append(result)
            else:
                result = move(way, new_way, has_visited)
                if len(result) and result[-1] == "end":
                    routes.append(result)
    return res
move("start")
print("Part 1: ", len(routes))


# Part 2
routes = []
def move2(node, route=["start"], has_visited=["start"]):
    if node == "end":
        return route
    res = []
    for way in paths[node]:
        if way != "start":
            twice = [has_visited.count(w) for w in has_visited if w.islower() and w != "start"]
            twice = 0 if not len(twice) else max(twice)
            if way not in has_visited or twice <= 1:
                new_way = route + [way]
                # check that the path is lower and that we have already visited a small cave twice
                if way.islower():
                    result = move2(way, new_way, has_visited+[way])
                    if len(result) and result[-1] == "end":
                        routes.append(result)
                else:
                    result = move2(way, new_way, has_visited)
                    if len(result) and result[-1] == "end":
                        routes.append(result)
    return res
move2("start")
print("Part 2: ", len(routes))

