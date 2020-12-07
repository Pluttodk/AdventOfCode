import time
information = open("2020/data/day7.txt").read().split("\n")

tree_structure = {}
bags = [[] for _ in range(len(information))]

#Not the best way to construct a tree...
for i,l in enumerate(information):
    l = l[0:-1]
    current_bag = " ".join(l.split("contain")[0].split(" ")[0:2])
    other_bags = l.split("contain")[1]
    bags = []
    if "no" in other_bags:
        continue
    elif "," in other_bags:
        for bag in other_bags.split(","):
            bags.append(" ".join(bag.strip().split(" ")[1:3]).strip())
    else:
        bags.append(" ".join(other_bags.strip().split(" ")[1:3]).strip())
    tree_structure[current_bag] = bags

#realised I had made it upside down. So reverse it such that we can back track in the tree
reverse_tree = {}
for k,v in tree_structure.items():
    for n in v:
        if n in reverse_tree:
            reverse_tree[n].append(k)
        else:
            reverse_tree[n] = [k]


# Recursivly go through the tree
def recursive(bags, name, tree):
    if name in tree:
        #Keep recursive
        for n in tree[name]:
            bags.append(n)
            recursive(bags, n, tree)
        return bags
    else:
        return bags

result = set(recursive([], "shiny gold", reverse_tree))
#Part 1:
print(len(result))

#Part 2:
tree_structure = {}
for i,l in enumerate(information):
    l = l[0:-1]
    current_bag = " ".join(l.split("contain")[0].split(" ")[0:2])
    other_bags = l.split("contain")[1]
    other_bags = other_bags.strip()
    bags = []
    if "no" in other_bags:
        continue
    elif "," in other_bags:
        for bag in other_bags.split(","):
            bag = bag.strip()
            bags.append((" ".join(bag.strip().split(" ")[1:3]).strip(), int(bag.split(" ")[0])))
    else:
        bags.append((" ".join(other_bags.strip().split(" ")[1:3]).strip(), int(other_bags.split(" ")[0])))
    tree_structure[current_bag] = bags

def part2(values, name, tree):
    if name in tree:
        vals = tree[name]
        for v, score in vals:
            values += score*part2(1, v, tree)
        return values
    else:
        return 1
l = part2(0, "shiny gold", tree_structure)
print(l)
