i = list(map(lambda x: x.strip(), open("1.in", "r").readlines()))

elfs = [[]]
for number in i:
    if number != "":
        elfs[-1].append(int(number))
    else:
        elfs.append([])

elfs_total = list(map(sum,elfs))

#1
print(max(elfs_total))

#2 
print(sum(sorted(elfs_total, reverse=True)[:3]))