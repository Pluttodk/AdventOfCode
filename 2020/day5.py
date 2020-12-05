import math
board_ids = open("2020/data/day5.txt").readlines()


results = []
for i in board_ids:
    i = i.strip()
    row_l, row_h = (0,127)
    column_l, column_h = (0,7)
    col, row = 0,0
    for v in i:
        row_middle = (row_h+row_l)/2
        column_middle = (column_h+column_l)/2
        if v == "F":
            if row_h-row_l == 1:
                row = row_l
            else:
                row_h = math.floor(row_middle)
        elif v == "B":
            if row_h-row_l == 1:
                row = row_h
            else:
                row_l = math.ceil(row_middle)
        elif v == "R":            
            if column_h-column_l == 1:
                col = column_h
            else:
                column_l = math.ceil(column_middle)
        elif v == "L":            
            if column_h-column_l == 1:
                col = column_l
            else:
                column_h = math.floor(column_middle)
    results.append(row*8+col)

results = list(sorted(results, reverse=True))
print(results[0])

for i in range(results[-1],results[1]):
    if i not in results:
        print(i)
