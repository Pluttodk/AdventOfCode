import re
import numpy as np

big_line = open("2020/data/day14.txt").read()
data = list(map(lambda x: x.split("\n"), big_line.split("mask = ")))[1:]
memory = {}

#part 1
for line in data:
   or_mask = int(line[0].replace("X", "0"), 2)
   and_mask = int(line[0].replace("X", "1"), 2)
   for val in line[1:]:
        if val == "":
            continue
        mem, value = val.split(" = ")
        updated_val = (int(value)|or_mask)&and_mask
        loc = int(mem.split("[")[1][:-1])
        memory[loc-1] = updated_val
print(sum(memory.values()))

#part 2
memory = {}
for k, line in enumerate(data):
    mask = line[0]
    largest_mask = int(mask.replace("X", "1"),2)
    for val in line[1:]:
        if val == "":
            continue
        mem, value = val.split(" = ")
        loc = int(mem.split("[")[1][:-1])
        largest_val = (loc|largest_mask)
        as_bit = list("{:036b}".format(largest_val))
        loc = []
        for i in range(len(mask)):
            if mask[i]=="X":
                as_bit[i]="X"
        un_filtered_mask = ["".join(as_bit)]
        masks = []
        while(len(un_filtered_mask)):
            l = list(un_filtered_mask.pop())
            for i in range(len(l)):
                if l[i]=="X":
                    for j in range(2):
                        l[i] = str(j)
                        if "X" in l:
                            un_filtered_mask.append("".join(l))
                        else:
                            masks.append("".join(l))
        masks = set(masks)
        for m in masks:
            memory[int(m,2)] = int(value)
print(sum(memory.values()))