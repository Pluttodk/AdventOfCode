jolts = open("2020/data/day10.txt").read().split("\n")
jolts = sorted(map(int, jolts))

#part 1
one_diff = 1
three_diff = 1
previous = jolts[0]
for j in jolts[1:]:
    if j-previous == 1:
        one_diff += 1
    elif j-previous == 3:
        three_diff += 1
    previous = j
print(one_diff, three_diff)
print(one_diff*three_diff)

#Part 3
def countmatchest(values, current, score, cache):
    if current in cache:
        return cache[current]
    found_match = False
    score = 0
    for i in range(1,4):
        if current+i in values:
            found_match = True
            score += countmatchest(values, current+i, 0, cache)
            print(f"checking for {current+i} with result {score}")
    
    if not found_match:
        return 1
        # print(permutations+[current])
    else:
        cache[current] = score
        return score

print(countmatchest(set(jolts), 0, 0, {}))