import tqdm
from numba import jit

sensor_val, beacon_val, obstructed_val = 1,2,3
vals = []
for line in open("15.in","r").read().split("\n"):
    sensor, beacon = line.split(": ")
    s_x, s_y = sensor.split("=")[1:]
    s_x, s_y = int(s_x.split(",")[0]), int(s_y)

    b_x, b_y = beacon.split("=")[1:]
    b_x, b_y = int(b_x.split(",")[0]), int(b_y)
    vals.append((s_x,s_y,b_x,b_y))

target_y = 2000000

# @jit(nopython=True)
def obscure(target_y, vals, remove_beacons=False):
    should_remove = []
    obscured = []
    for s_x, s_y, b_x, b_y in vals:
        if b_y == target_y:
            should_remove.append(b_x)
        if s_y == target_y:
            should_remove.append(s_x)

        # Dist
        dist = abs(s_x - b_x) + abs(s_y - b_y)

        # Can we reach target row?
        
        if (target_y > s_y and target_y <= dist + s_y) or (
            target_y < s_y and target_y >= s_y - dist
        ) or target_y == s_y:
            if target_y > s_y and target_y <= dist + s_y:
                spread = dist + s_y - target_y
            elif target_y == s_y:
                spread = dist
            else:
                spread = abs((s_y - dist) - target_y)
            obscured += list(range(s_x-spread, s_x+spread+1))
            # for reachable_x in range(s_x-spread, s_x+spread+1):
                # obscured.append(reachable_x)
    if remove_beacons:  
        return set([o for o in obscured if o not in should_remove])
    else:
        return set(obscured)

print(len(obscure(10, vals, True)))

# Part 2
g_bounds = 0,4_000_000
for target_y in tqdm.tqdm(range(g_bounds[1]+1)):
    could_be = []
    bounds = []
    for s_x, s_y, b_x, b_y in vals:
        # Dist
        dist = abs(s_x - b_x) + abs(s_y - b_y)
        # Can we reach target row?
        if (target_y > s_y and target_y <= dist + s_y) or (
            target_y < s_y and target_y >= s_y - dist
        ) or target_y == s_y:
            if target_y > s_y and target_y <= dist + s_y:
                spread = dist + s_y - target_y
            elif target_y == s_y:
                spread = dist
            else:
                spread = abs((s_y - dist) - target_y)
            bounds.append((s_x-spread, s_x+spread))
            could_be += [s_x-spread-1, s_x+spread+1]
    for c in could_be:
        if g_bounds[0] <= c <= g_bounds[1]:
            can_be = True
            for bl, bh in bounds:
                if bl <= c <= bh:
                    can_be = False 
            if can_be:
                print(target_y + c*4000000)
    
        # for reachable_x in range(s_x-spread, s_x+spread+1):
            # obscured.append(reachable_x)

# def part2(upper_bound):
#     for target_y in tqdm.tqdm(range(0,upper_bound+1)):
#         o = obscure(target_y, vals)
#         for target_x in range(0,upper_bound+1):
#             if target_x not in o:
#                 return target_y + target_x*4000000
# print(part2(4000000))