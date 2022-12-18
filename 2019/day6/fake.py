import sys
in6 = sys.stdin.readlines()
orbits = {}
for line in in6:
    source, orbiter = line.split(')')
    orbits[orbiter.strip()] = source

# part 1
norb = 0
for k in orbits.keys():
    s = orbits.get(k, None)
    while s:
        norb += 1
        s = orbits.get(s, None)


# part 2
def get_path(orbit_dict, start):
    path = []
    obj = orbit_dict[start]
    while obj:
        path.append(obj)
        obj = orbit_dict.get(obj, None)
    return path


path_santa = get_path(orbits, 'SAN')
path_you = get_path(orbits, 'YOU')

min_transfers = 1e5
for i, p in enumerate(path_you):
    try:
        san_way = path_santa.index(p)
    except ValueError:
        continue
    total_way = i + san_way
    if total_way < min_transfers:
        min_transfers = total_way

print(norb, min_transfers)
