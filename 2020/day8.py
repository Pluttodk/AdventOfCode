lines = open("2020/data/day8.txt").read().split("\n")


def part1(lines):
    accumulater = 0
    lines_pos_visited  = []
    pos = 0
    while(pos not in lines_pos_visited and pos < len(lines)):
        current_line = lines[pos].split(" ")
        val = +int(current_line[1][1:]) if current_line[1][0] == "+" else -int(current_line[1][1:])
        if current_line[0] == "acc":
            accumulater += val
            lines_pos_visited.append(pos)
            pos += 1
        elif current_line[0] == "jmp":
            lines_pos_visited.append(pos)
            pos += int(val)
        else:
            lines_pos_visited.append(pos)
            pos += 1
    return accumulater,pos
#Part 1
print(part1(lines))

# Part 2
ids_acc = []
ids_nop = []
for i in range(len(lines)):
    if lines[i].startswith("jmp"):
        ids_acc.append(i)
    elif lines[i].startswith("nop"):
        ids_nop.append(i)
for i in ids_acc:
    lines[i] = "nop" + lines[i][3:]
    accumulater,pos = part1(lines)
    if pos >= len(lines):
        print(accumulater)
        break
    lines[i] = "jmp" + lines[i][3:]