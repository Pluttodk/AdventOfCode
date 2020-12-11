import copy

def adjacent_1(seats, col, row):
    adj = []
    start = 0 if col-1 < 0 else col-1
    start_row = 0 if row-1 < 0 else row-1
    end_row = len(seats[0]) if row+2 > len(seats[0]) else row+2
    end = len(seats) if col+2 > len(seats) else col+2
    for cols in range(start, end):
        for rows in range(start_row,end_row):
            if cols == col and rows == row:
                continue
            if seats[cols][rows] == "#":
                adj.append(seats[cols][rows])
    return adj

def adjacent_2(seats, col, row):
    adj = []
    for cols in range(-1,2):
        for rows in range(-1,2):
            pos_col = cols+col
            pos_row = row+rows
            looking = True
            while(looking):
                if not (0 <= pos_col <= len(seats)-1):
                    break

                if not (0 <= pos_row <= len(seats[0])-1):
                    break

                if rows == 0 and cols == 0:
                    break

                if seats[pos_col][pos_row] == "#":
                    adj.append(seats[pos_col][pos_row])
                    looking = False
                elif seats[pos_col][pos_row] == ".":
                    pos_row += rows
                    pos_col += cols
                else:
                    looking = False
    return adj
            
def day11(PART1):
    seats = open("2020/data/day11.txt").read().split("\n")
    seats = [[st for st in s] for s in seats]
    previous_round = copy.deepcopy(seats)
    min_occupied = 4 if PART1 else 5
    adjacent = adjacent_1 if PART1 else adjacent_2

    while(True):
        for col in range(len(seats)):
            for row in range(len(seats[col])):
                seat = previous_round[col][row]
                occupied = len(adjacent(previous_round, col, row))
                if seat == "L" and occupied == 0:
                    seats[col][row] = "#"
                elif seat == "#" and occupied >= min_occupied:
                    seats[col][row] = "L"
        # print(previous_round)
        # for s in seats:
        #     print(s)
        # print("---------------")
        if previous_round == seats:
            break
        # else:
        previous_round = copy.deepcopy(seats)

    vals = [[1 if s == "#" else 0 for s in row] for row in seats]
    vals = sum((sum(row) for row in vals))
    print(vals)

print("Part 1")
day11(True)
print("Part 2")
day11(False)