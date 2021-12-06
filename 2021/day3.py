value = open("data/day3.txt").readlines()

bit = ""
siz = len(value[0].strip())
for i in range(siz):
    focus_area = [v[i] for v in value]
    bit += max(["0","1"], key=list(focus_area).count)

gamma = int(bit, 2)
epsilon = (1 << siz) - 1 - gamma
#Part 1
print(gamma*epsilon)

# Part 2
def find_rating(vals, pos, max_siz, f=max, default="1"):
    if len(vals) == 1:
        return vals[0]
    else:
        if pos >= max_siz:
            pos = 0
        focus_area = [v[pos] for v in vals]
        if focus_area.count("0") == focus_area.count("1"):
            mc = default
        else:
            mc = str(f(["0", "1"], key=list(focus_area).count))
        vals = list(filter(lambda x: x[pos] == mc, vals))
        return find_rating(vals, pos+1, max_siz,f,default)

ox = find_rating(value, 0, siz)
co2 = find_rating(value, 0, siz, f=min, default="0")
print(int(ox, 2)*int(co2,2))