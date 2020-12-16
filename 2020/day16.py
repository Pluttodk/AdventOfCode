import numpy as np

valid_tickets = []

ranges, tickets = open("2020/data/day16.txt").read().split("\nyour ticket:\n")
ranges = ranges.split("\n")[:-1]
tickets = tickets.split("\n")
your_ticket, other_ticket = tickets[0], tickets[3:]

out_of_range = []
for ticket in other_ticket:
    ticket_vals = np.array(list(map(int, ticket.split(","))))
    for r in ranges:
        v = r.split(": ")[1]
        l,h = tuple(map(lambda x: x.split("-"), v.split(" or ")))
        ticket_vals = ticket_vals[(int(l[0]) > ticket_vals) | (int(l[1]) < ticket_vals)]
        ticket_vals = ticket_vals[(int(h[0]) > ticket_vals) | (int(h[1]) < ticket_vals)]
    if not len(ticket_vals):
        valid_tickets.append(ticket)
    for i in ticket_vals:
        out_of_range.append(i)
#Part 1
print("Part 1", sum(out_of_range))

#part 2
res = list(map(lambda x: list(map(int, x.split(","))), valid_tickets))
mapping = {}
for i, criteria in enumerate(ranges):
    legal_rows = [i for i in range(len(ranges))]
    l,h = criteria.split(": ")[1].split(" or ")
    l1, l2 = map(int, l.split("-"))
    h1, h2 = map(int, h.split("-"))
    for pos in range(len(ranges)):
        for t in res:
            if (l1 <= t[pos] <= l2) or (h1 <= t[pos] <= h2):
                continue
            else:
                legal_rows.remove(pos)
                break
    mapping[i] = legal_rows
mapping = list(sorted(mapping.items(), key=lambda x: len(x[1])))
idxs = [x[0] for x in mapping]
values_original = mapping
i = 0
visited = []
values = values_original
has_tried = []
while(len(visited) != len(your_ticket.split(","))):
    _, val = values[i]
    start_size = len(visited)
    should_continue = False
    for v in val:
        if not (v in visited) and not (visited + [v] in has_tried):
            visited.append(v)
            i+=1
            should_continue = True
            break
    if should_continue:
        continue
    if start_size == len(visited):
        has_tried.append(visited)
        visited = visited[:-1]
        i-=1
your_ticket = list(map(int, your_ticket.split(",")))
final_res = []
for loc, val in zip(idxs, visited):
    final_res.append((loc, val))

final_res = sorted(final_res, key=lambda x: x[0])
res = 1
for _,v in final_res[:6]:
    res *= your_ticket[v]
print("Part 2", res)