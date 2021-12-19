lines = open("data/day14.txt").readlines()
polymer = lines[0].strip()

rules = {}
for line in lines[2:]:
    line = line.strip()
    f,t = line.split(" -> ")
    rules[f] = f[0]+t+f[1]

def rec_grow(rules, polymer, i = 0, max_days=10, cache={}):
    """
    Method is not usable. Only usable to get the actual output string. But once we go to 40 the string reaches memory limit
    """
    if i >= max_days:
        return polymer
    poly = ""
    splits = [polymer[i:i+2] for i in range(len(polymer)-1)]
    for split in splits:
        if split in cache and cache[split][i] != "":
            # We have seen the same behaviour at this particular time (so we know how it will look in the end)
            poly += cache[split][i] if poly == "" else cache[split][i][1:]
        elif split in rules:
            result = rec_grow(rules, rules[split], i+1,max_days, cache)
            if split in cache:
                cache[split][i] = result
            else:
                cache[split] = ["" if i != j else result for j in range(max_days)]
            poly += result if poly == "" else result[1:]
        else:
            poly += split
    return poly

def rec_grow_count(rules, polymer, i = 0, max_days=10, cache={}):
    """
    Actual usable method. Only works on the len of the list rather than the string
    """
    if i >= max_days:
        return {c: polymer.count(c) for c in set(polymer)}

    count = {}
    splits = [polymer[i:i+2] for i in range(len(polymer)-1)]
    for k, split in enumerate(splits):
        if split in cache and len(cache[split][i]):
            # We have seen the same behaviour at this particular time (so we know how it will look in the end)
            result = cache[split][i]
        elif split in rules:
            result = rec_grow_count(rules, rules[split], i+1,max_days, cache)
            if split in cache:
                cache[split][i] = result
            else:
                cache[split] = [{} if i != j else result for j in range(max_days)]
        else:
            result = {c: polymer.count(c) for c in set(polymer)}
        for c, occurences in result.items():
            if c in count:
                count[c] += occurences
            else:
                count[c] = occurences
        # Take account that we only take one split once. E.g. BB -> C and BBB should become BCBCB and not BCBBCB
        if k and split in rules:
            count[split[0]] -= 1
    return count

count = rec_grow_count(rules, polymer,0, 10)
occurrences = sorted(list(count.items()), key=lambda x: x[1], reverse=True)
print("Part 1: ", occurrences[0][1]-occurrences[-1][1])

count = rec_grow_count(rules, polymer,0, 40, cache={})
occurrences = sorted(list(count.items()), key=lambda x: x[1], reverse=True)
print("Part 2: ", occurrences[0][1]-occurrences[-1][1])


