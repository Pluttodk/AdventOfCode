import numpy as np
import tqdm
vals = open("data/day8.txt").readlines()

print("="*10+"Part 1"+"="*10)
# Part 1
easy_digits = np.array([l.strip().split(" | ")[1].split(" ") for l in vals]).flatten()
numbers =list(map(len, easy_digits))
accepted_lens = (2,3,4,7)
print(len(list(filter(lambda x: x in accepted_lens, numbers))))

print("="*10+"Part 2"+"="*10)
# Part 2
def calc_digits(line):
    chars = ["a", "b", "c", "d", "e", "f", "g"]
    voting_system = {
        0: [0]*7,
        1: [0]*7,
        2: [0]*7,
        3: [0]*7,
        4: [0]*7,
        5: [0]*7,
        6: [0]*7,
    }
    digit_map = {
        0: [0,1,2,4,5,6],
        1: [2,5],
        2: [0,2,3,4,6],
        3: [0,2,3,5,6],
        4: [1,2,3,5],
        5: [0,1,3,5,6],
        6: [0,1,3,4,5,6],
        7: [0,2,5],
        8: [0,1,2,3,4,5,6],
        9: [0,1,2,3,5,6]
    }

    length_to_number = {
        2: 1,
        3: 7,
        4: 4,
        7: 8
    }

    board_map = {
        "abcefg" : 0,
        "cf" : 1,
        "acdeg" : 2,
        "acdfg": 3,
        "bcdf": 4,
        "abdfg": 5,
        "abdefg": 6,
        "acf": 7,
        "abcdefg": 8,
        "abcdfg": 9
    }
    line = line.strip()
    output = line.split(" | ")[1]
    words = np.array(line.replace(" | ", " ").split(" "))
    words_siz = np.array(list(map(len, words)))
    for lens in accepted_lens:
        voters = words[words_siz == lens]
        for comb in voters:
            for char in comb:
                for loc in digit_map[length_to_number[lens]]:
                    char_pos = chars.index(char)
                    voting_system[loc][char_pos] += 1

    board = {}
    score = sorted(voting_system.items(), key=lambda x: sum(x[1]),reverse=True)
    for pos, ranking in score:
        chars_to_use = [chars[i] for i,x in enumerate(sorted(ranking, reverse=True)) if x > 0]
        board[chars[pos]] = chars_to_use
    swap_board = {}
    vals = list(board.values())
    # Try every combination of solution. If it works than stop
    combination = [
        (a,b,c,d,e,f,g) for a in vals[0] for b in vals[1] for c in vals[2] for d in vals[3] for e in vals[4] for f in vals[5] for g in vals[6] 
        if len(set([a,b,c,d,e,f,g])) == 7
        ]
    sorted_combination = sorted(
        combination, 
        key= lambda x: sum([voting_system[chars.index(key)][chars.index(xi)] for xi, (key,_) in zip(x, board.items())]), 
        reverse=True
    )
    
    # print(combination)
    for comb in sorted_combination:
        done_trying = True
        swap_board = {c:key for c,(key,_) in zip(comb, board.items())}
        value = ""
        for w in output.split(" "):
            # Do mapping back to numbers using board
            actual_word = "".join(sorted([swap_board[c] for c in w]))
            try:
                value += str(board_map[actual_word])
            except:
                done_trying = False
                break
        if done_trying:
            break
    return int(value)

result = [calc_digits(vals[i]) for i in tqdm.tqdm(range(len(vals)))]
print(f"Part 2 result: {sum(result)}")