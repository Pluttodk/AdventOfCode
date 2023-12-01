import re

values = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five":5,
    "six":6,
    "seven":7,
    "eight":8,
    "nine":9
}

# Part 1
data_part1 = list(map(lambda x: re.findall("\d", x.strip()), open("1.in").readlines()))
s = 0
for i in data_part1:
    s += int(i[0] + i[-1])
print("Part 1: ", s)

# Part 2
rem = "one|two|three|four|five|six|seven|eight|nine"
lines = list(map(lambda x: x.strip(), open("1.in").readlines()))
res = []
for i in range(len(lines)):
    first, last = None, None
    # Find first digit
    for j in range(len(lines[i])):
        if lines[i][j].isdigit():
            first = int(lines[i][j])
            break
        elif any(k in lines[i][:j+1] for k in values.keys()):
            first = re.findall(rem, lines[i][:j+1])[0]
            first = values[first]
            break
    for j in range(len(lines[i])-1, 0, -1):
        if lines[i][j].isdigit():
            last = int(lines[i][j])
            break
        elif any(k in lines[i][j:] for k in values.keys()):
            last = re.findall(rem, lines[i][j:])[0]
            last = values[last]
            break
    if last is None:
        last = first
    if first is None:
        first = last
    res.append(int(str(first) + str(last)))
# for line, l in zip(lines, res):
#     print(line, "=>", l)
print("Part 2: ", sum(res))