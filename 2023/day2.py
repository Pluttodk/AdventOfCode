lines = list(map(lambda x: x.strip(), open("2.in").readlines()))

part1 = 0

part2 = []
for i, game in enumerate(lines):
    game, buckets = game.split(":")
    subsets = buckets.split(";")
    red, green, blue = [],[],[]
    for subset in subsets:
        chosen = subset.split(", ")
        selections = {
            values.strip().split(" ")[1]: int(values.strip().split(" ")[0])
            for values in chosen
        }
        if "red" in selections:
            red.append(selections["red"])
        if "green" in selections:
            green.append(selections["green"])
        if "blue" in selections:
            blue.append(selections["blue"])
    max_red, max_green, max_blue = max(red), max(green), max(blue)
    if max_red <= 12 and max_green <= 13 and max_blue <= 14:
        part1 += i+1
    
    part2.append(max_red*max_green*max_blue)
print("Part 1: ", part1)
print("Part 2: ", sum(part2))