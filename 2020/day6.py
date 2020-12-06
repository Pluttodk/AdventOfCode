data = open("2020/data/day6.txt")
lines = data.readlines()

#Part 1
values = []
group_answer = ""
for line in lines:
    if line.strip() != "":
        group_answer += line.strip()
    else:
        values.append(len(set(group_answer)))
        group_answer = ""
# print(values)
print(sum(values))

#Part 2
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
print(sum(values))