import sys
import collections

def solve1():
    # A dictionary pointing to where it came from.
    # Backtracking until we reach COM which is our terminal
    paths = {}
    for n in sys.stdin.readlines():
        f,t = n.split(")")
        paths[t.strip()] = f.strip()
    i = 0
    for n in paths:
        while n!='COM':
            i += 1
            n = paths[n]
    print(i)

#PARSING
V ={}
for line in sys.stdin.readlines():
    #T is always a new one
    #f is not guaranteed to be new
    f,t = line.split(")")
    V[t.strip()] = f

def get_path(orbit_dict, start):
    path = []
    obj = orbit_dict[start]
    while obj:
        path.append(obj)
        obj = orbit_dict.get(obj, None)
    return path

path_santa = get_path(V, 'SAN')
path_you = get_path(V, 'YOU')

shortest_path = float("inf")
for i, orbit in enumerate(path_you):
    if orbit in path_santa:
        distance = i + path_santa.index(orbit)
        shortest_path = distance if distance < shortest_path else shortest_path
print(shortest_path)
