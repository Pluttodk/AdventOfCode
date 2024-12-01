data = open("1.in", "r").readlines()
l, r = zip(*(map(lambda x: map(int, x.split("   ")), data)))
dist = 0
sim_score = 0
for low_l, low_r in zip(sorted(l), sorted(r)):
    dist += abs(low_r-low_l)
print(dist)

similarity_score = 0
for li in l:
    similarity_score += li * r.count(li)
print(similarity_score)