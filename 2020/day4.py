import re

file = open("2020/data/day4.txt")
info = []
partial = " "
for line in file.readlines():
    if not (line.strip() == ""):
        partial += line.strip() + " "
    else:
        info.append(partial)
        partial = ""

criteria = "^(?=.*(byr).*)(?=.*hcl.*)(?=.*iyr.*)(?=.*eyr.*)(?=.*hgt.*)(?=.*ecl.*)(?=.*pid.*).*$"
#Part 1
legal_passboards = 0
for l in info:
    if re.fullmatch(criteria, l.strip()):
        legal_passboards += 1
print(legal_passboards)


# Part 2
hcl = ".*(hcl:#[0-9a-z]{6}){1}.*"
byr = ".*(byr:([1][9][23456789][0-9]|[2][0][0][0-2])){1}.*"
iyr = ".*(iyr:([2][0][1][0-9]|[2][0][2][0]){1}).*"
eyr = ".*(eyr:([2][0][2][0-9]|[2][0][3][0]){1}).*"
hgt = ".*(hgt:((([1][5-8][0-9]|[1][9][0-3])cm){1}|([5][9]|[6][0-9]|[7][0-6])in){1}).*"
ecl = ".*(ecl:#(amb|brn|gry|hzl|oth|grn|blu){1}).*"
pid = ".*(pid:[0-9]{9}).*"

large_regex = "^(?=.*(hcl:#[0-9a-z]{6}){1})(?=.*(byr:([1][9][23456789][0-9]|[2][0][0][0-2])){1})(?=.*(iyr:([2][0][1][0-9]|[2][0][2][0]){1}))(?=.*(eyr:([2][0][2][0-9]|[2][0][3][0]){1}))(?=.*(hgt:((([1][5-8][0-9]|[1][9][0-3])[c][m]){1}|([5][9]|[6][0-9]|[7][0-6])[i][n]){1}))(?=.*(ecl:(amb|brn|gry|hzl|oth|grn|blu){1}))(?=.*(pid:[0-9]{9} )).*$"

legal_password = 0
for password in info:
    if re.fullmatch(large_regex, password):
        legal_password += 1
print(legal_password)