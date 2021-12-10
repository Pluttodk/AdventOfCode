import numpy as np
lanterns = list(map(int, open("data/day6.txt").readlines()[0].split(",")))

# part 1 slow...
def grow(lanterns, days=80):
    siz = {}
    for i in range(days):
        lanterns = lanterns - 1
        not_zeros = lanterns[lanterns >=0]
        dif = len(lanterns)-len(not_zeros)
        if dif > 0:
            lanterns = np.concatenate((
                not_zeros,
                np.zeros(dif)+6,
                np.zeros(dif)+8
            ))
        siz[i] = len(lanterns)
    return siz

lanterns = list(map(int, open("data/day6.txt").readlines()[0].split(",")))
# DP version
def calc_score(day, life, cache = {}):
    idx = f"{day}-{life}"
    if idx in cache:
        return cache[idx]
    if day == 0:
        cache[idx] = 1
        return 1
    elif life == 0:
        cache[idx] = calc_score(day-1, 6) + calc_score(day-1, 8)
        return cache[idx]
    else:
        cache[idx] = calc_score(day-1, life-1)
        return cache[idx]

lookup = [calc_score(256, i) for i in range(1, 10)]
res = [lookup[l-1] for l in lanterns]
print(sum(res))


