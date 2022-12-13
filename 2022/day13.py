pairs = open("13.in","r").read().split("\n\n")

def comp(l,r):
    if isinstance(l, list) and isinstance(r, list):
        l_length = len(l)
        r_length = len(r)
        if l_length == r_length:
            for l1,r1 in zip(l,r):
                res = comp(l1,r1)
                if res == 2:
                    return 2
                elif not res:
                    return 0
            return 1
        elif l_length < r_length:
            for i in range(l_length):
                res = comp(l[i],r[i])
                if res == 1:
                    continue
                return res
            return 2
        else:
            for i in range(r_length):
                res = comp(l[i],r[i])
                if res == 1:
                    continue
                return res
            return 0
    elif isinstance(l, int) and isinstance(r, int):
        return int(l <= r) + int(l < r)
    elif isinstance(l, list) and isinstance(r, int):
        return comp(l,[r])
    elif isinstance(l, int) and isinstance(r, list):
        return comp([l],r)
    else:
        return 1

result = []
lists = []
for i, pair in enumerate(pairs):
    l, r = pair.split("\n")
    l,r = eval(l), eval(r)
    lists.append(l)
    lists.append(r)
    if comp(l,r) == 2:
        result.append(i+1)
print(result, sum(result))

decoder_keys = (
    [[2]],[[6]]
)
for d in decoder_keys:
    lists.append(d)

from functools import cmp_to_key

def comp2(l,r):
    return comp(l,r) -1
    
sort = sorted(lists, key=cmp_to_key(comp2), reverse=True)
res = 1
for i,l in enumerate(sort):
    if str(l) == str(decoder_keys[0]) or str(l) == str(decoder_keys[1]):
        res*=i+1
print(res)