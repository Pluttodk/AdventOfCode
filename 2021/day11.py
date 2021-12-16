import numpy as np

octopus = open("data/day11.txt").readlines()

octopus = np.array([list(map(int, l.strip())) for l in octopus])
flashes = 0
first_time = -1
day = 0
while True:
    day += 1
    octopus += 1 # increase all values by one

    # Do the flashy thingy
    locs = np.array(np.where(octopus==10)).T
    while len(locs):
        for x,y in locs:
            octopus[x,y] += 1 # increase our self
            flashes += 1
            low_x, high_x = max((x-1,0)), min((x+2, len(octopus)+1))
            low_y, high_y = max((y-1,0)), min((y+2, len(octopus[0])+1))
            area_interest = octopus[low_x: high_x, low_y:high_y]
            octopus[low_x: high_x, low_y:high_y][area_interest<10] +=1
        locs = np.array(np.where(octopus==10)).T
    # Reset at the end of the day
    if all(octopus.flatten() >= 10):
        print("Part 2: ", day)
        break
    octopus[octopus >= 10] = 0
    if day == 100:
        # Part 1
        print("Part 1: ", flashes)


