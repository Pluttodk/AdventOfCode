import re

formulas = open("2020/data/day18.txt").read().split("\n")

def parse_formula(formula):
    paranthesese = re.findall(r"\([0-9*+ ]*\)", formula)
    for p in paranthesese:
        p = p[1:-1]
        formula = formula.replace("(" + p + ")",str(parse_formula(p)))
    if "(" in formula:
        return parse_formula(formula)
    symbols = formula.split(" ")
    val = int(symbols[0])
    for symbol,opperator in zip(symbols[2::2],symbols[1::2]):
        if opperator == "+":
            val += int(symbol)
        elif opperator == "*":
            val *= int(symbol)
    return val

results = [parse_formula(f) for f in formulas]
print(sum(results))

def parse_formula_part2(formula):
    paranthesese = re.findall(r"\([0-9*+ ]*\)", formula)
    for p in paranthesese:
        p = p[1:-1]
        formula = formula.replace("(" + p + ")",str(parse_formula_part2(p)))
    if "(" in formula:
        return parse_formula_part2(formula)
    addition = re.findall("[0-9]+ [+] {1}[0-9]+", formula)
    for a in addition:
        v1,v2 = a.split(" + ")
        formula = formula.replace(" " + a, " "+str(int(v1)+int(v2)))
        formula = formula.replace(a+ " ", str(int(v1)+int(v2)) + " ")
        if formula == a:
            formula = str(int(v1)+int(v2))
    if "+" in formula:
        return parse_formula_part2(formula)
    symbols = formula.split(" ")
    val = int(symbols[0])
    for symbol,opperator in zip(symbols[2::2],symbols[1::2]):
        if opperator == "*":
            val *= int(symbol)
    return val
res = 0
for f in formulas:
    res += parse_formula_part2(f)
print(res)