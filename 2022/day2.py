scores = {
    "A": 1,
    "B": 2,
    "C": 3,
    "X": 1,
    "Y": 2,
    "Z": 3
}
moves = open("2.in", "r").read().split("\n")
# Part 1
rewards = []
for move in moves:
    o, y = move.split(" ")
    if (o == "A" and y == "Y") or (o=="B" and y=="Z") or (o=="C" and y=="X"):
        rewards.append(scores[y]+6)
    elif scores[o] == scores[y]:
        rewards.append(scores[y]+3)
    else:
        rewards.append(scores[y]+0)
print(sum(rewards))

# Part 2
rewards = []
map_moves = {
    "A": [3, 1, 2],
    "B": [1, 2, 3],
    "C": [2, 3, 1] 
}
for move in moves:
    o, y = move.split(" ")
    if y == "X":
        rewards.append(map_moves[o][0]+0)
    elif y == "Y":
        rewards.append(map_moves[o][1]+3)
    else:
        rewards.append(map_moves[o][2]+6)
print(sum(rewards))
        
    