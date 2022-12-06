stacks, actions = open("5.in", "r").read().split("\n\n")

elements = []
for stack in stacks.split("\n")[:-1]:
    elements.append([stack[i+1] for i in range(0, len(stack), 4)])

# Stack is correctly orriented after this step
stacks = [list(filter(lambda x: x != " ", e)) for e in zip(*elements)]

def part1_reorder(x,y,z):
    for _ in range(int(x)):
        val = stacks[int(y)-1].pop(0)
        stacks[int(z)-1] = [val] + stacks[int(z)-1]

def part2_reorder(x,y,z):
    elements = [stacks[int(y)-1].pop(0) for _ in range(int(x))]
    stacks[int(z)-1] = elements + stacks[int(z)-1]
    
for action in actions.split("\n"):
    # move x from y to z
    _,x,_,y,_,z = action.split(" ")
    # part1_reorder(x,y,z)
    part2_reorder(x,y,z)
print("".join([s[0] for s in stacks]))

