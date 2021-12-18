import sys
sys.setrecursionlimit(10000000) # 10000 is an example, try with different values

lines = open("data/day14.txt").readlines()
polymer = lines[0].strip()

rules = {}
for line in lines[2:]:
    line = line.strip()
    f,t = line.split(" -> ")
    rules[f] = f[0]+t+f[1]

def grow(rules, polymer):
    output = ""
    for low in range(len(polymer)-1):
        high = low+2
        new_part = polymer[low:high]
        if new_part in rules:
            if output == "":
                output += rules[new_part]
            else:
                output += rules[new_part][1:]
        else:
            output += new_part
    return output

def dp_grow(cache, polymer):
    """
    Cache now also contains rules and seen bits (to do this recursively)
    """
    if polymer in cache:
        return cache[polymer]
    elif len(polymer) == 2:
        return polymer
    else:
        first_part = polymer[:2] if polymer[:2] not in cache else cache[polymer[:2]]
        cache[polymer] = first_part + dp_grow(cache, polymer[1:])[1:]
        return cache[polymer]

for day in range(20):
    polymer = dp_grow(rules, polymer)
    print(day)
occurrences = sorted([polymer.count(c) for c in set(polymer)], reverse=True)
print("Part 1: ", occurrences[0]-occurrences[-1])


