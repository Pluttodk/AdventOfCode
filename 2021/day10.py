lines = open("data/day10.txt").readlines()

para_map = {")": "(", ">": "<", "]": "[", "}": "{"}
para_correct = {v:k for k,v in para_map.items()}

crashed = []
okay_line = []
score = []
score_board = {")": 1, "]": 2, "}": 3, ">": 4}
for paranthesis in lines:
    paranthesis = paranthesis.strip()
    opens = []
    crash = False
    for i in range(len(paranthesis)):
        if paranthesis[i] in para_correct:
            opens.append(para_correct[paranthesis[i]])
        elif paranthesis[i] in para_map:
            close = opens[-1]
            opens = opens[:-1]
            if paranthesis[i] != close:
                crashed.append(paranthesis[i])
                crash = True
                break
    if not crash:
        score_c = 0
        for o in opens[::-1]:
            score_c *= 5
            score_c += score_board[o]
        score.append(score_c)
        okay_line.append(paranthesis)
scores = {")": 3, "]": 57, "}": 1197, ">": 25137}

print(f"Part 1: {sum([scores[c] for c in crashed])}")
print(f"Part 2: {sorted(score)[len(score)//2]}")