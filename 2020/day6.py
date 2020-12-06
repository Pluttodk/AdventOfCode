
part1 = sum((len(set(x.replace("\n", ""))) for x in open("2020/data/day6.txt").read().split("\n\n")))
part2 = sum((len(set.intersection(*map(set, x.split("\n")))) for x in open("2020/data/day6.txt").read().split("\n\n")))

#Using map instead of for loop
#part1
print(sum(map(lambda x: len(set(x.replace("\n", ""))), open("2020/data/day6.txt").read().split("\n\n"))))
#part 2
print(sum(map(lambda x: len(set.intersection(*map(set, x.split("\n")))), open("2020/data/day6.txt").read().split("\n\n"))))

#A concatenation of both
print(list(map(sum, (zip(*map(lambda x: (len(set(x.replace("\n", ""))),len(set.intersection(*map(set, x.split("\n"))))), open("2020/data/day6.txt").read().split("\n\n")))))))


# Old and not cool code :P 

data = open("2020/data/day6.txt")
lines = data.readlines()

def part_1():
    values = []
    group_answer = ""
    for line in lines:
        if line.strip() != "":
            group_answer += line.strip()
        else:
            values.append(len(set(group_answer)))
            group_answer = ""
    return (sum(values))

#Part 2
def part_2():
    values = []
    group_answer = ""
    first_line = True
    for line in lines:
        if line.strip() != "":
            if first_line:
                group_answer = line.strip()
                first_line = False
            else:
                for c in group_answer:
                    if not (c in line.strip()):
                        group_answer = group_answer.replace(c, '')
        else:
            values.append(len(group_answer))
            group_answer = []
            first_line = True
    return (sum(values))