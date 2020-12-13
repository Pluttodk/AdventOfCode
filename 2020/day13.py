data = open("2020/data/day13.txt").read().split("\n")
#Part 1
busid = int(data[0])
time_stamps = data[1].split(",")
dep = []
for t in time_stamps:
    if t != "x":
        previous = busid % int(t)
        next_bus = int(t)-previous
        dep.append((next_bus, int(t)))
best = list(sorted(dep, key=lambda x: x[0]))[0]
print(best[0]*best[1])
print(best)


time_stamps = data[1].split(",")
dep2 = []
for shift, t in enumerate(time_stamps):
    if t != "x":
        dep2.append((shift, int(t)))
i = 0
move = dep2[0][1]

#paste equation into wolfram alpha
output = ""
for shift, t in dep2:
    output += f"(n+{shift})%{t} = "
output += "0"
print(output)

