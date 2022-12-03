rucksacks = open("3.in", "r").read().split("\n")

items = []
for rucksack in rucksacks:
    comp1, comp2 = rucksack[:len(rucksack)//2], rucksack[len(rucksack)//2:]
    item = set(comp1).intersection(comp2).pop()
    if str.islower(item):
        # Ascii value 
        val = ord(item)-96
    else:
        val = ord(item)-38
    items.append(val)
print(sum(items))

items = []
for i in range(0,len(rucksacks), 3):
    item = set(rucksacks[i]).intersection(rucksacks[i+1]).intersection(rucksacks[i+2]).pop()
    if str.islower(item):
        val = ord(item)-96
    else:
        val = ord(item)-38
    items.append(val)
print(sum(items))
