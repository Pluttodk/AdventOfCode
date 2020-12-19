import re

criteria, lines = open("2020/data/day19.txt").read().split("\n\n")
criteria = criteria.split("\n")
temp = {}
for c in criteria:
    a,b = c.split(": ")
    temp[int(a)] = b
criteria = temp
#Only for experiment 2
criteria[8] = "42 | 42 8"
criteria[11] = "42 31 | 42 11 31"

def parse(index, lines, cache, looped):
    if index == 11 or index == 8:
        looped += 1
    if looped > 10:
        return ""
    if index in cache:
        return cache[index]
    next_info = lines[index]
    if next_info == '"a"' or next_info == '"b"':
        cache[index] = next_info[1:-1]
        return next_info[1:-1]
    else:
        result = "("
        for val in next_info.split(" "):
            if val == "|":
                result += "|"
            else:
                result += parse(int(val), lines, cache, looped)
        result += "){1}"
        cache[index] = result
        return result

regex = parse(0, criteria, {},0)
regex = "^" + regex + "$"
res = 0
for l in lines.split("\n"):
    val = re.fullmatch(regex, l)
    if val != None:
        res += 1
print(res)