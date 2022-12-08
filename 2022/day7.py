import networkx as nx
import uuid
commands = open("7.in","r").read().split("$")
files = []
total_size = 0
structure = nx.DiGraph()
curr_folder = "/"
for command in commands[2:]:
    if "command.strip().startswith("cd"):
        directory = command.split(" ")[-1].replace("\n", "")
        if directory == "..":
            curr_folder = list(structure.predecessors(curr_folder))[0]
        else:
            directory = curr_folder + directory
            structure.add_edge(curr_folder, directory)
            curr_folder = directory
    elif "ls" in command.split("\n")[0]:
        for file in command.split("\n")[1:]:
            if not file.startswith("dir") and len(file.split(" ")) == 2:
                size, name = file.split(" ")
                name += ".file" + str(uuid.uuid4())
                structure.add_edge(curr_folder, name, weight=int(size))
                total_size += int(size)
                files.append((int(size), name))
scores = []
for node in nx.nodes(structure):
    score = 0
    if node not in list(map(lambda x: x[1], files)):
        for size, file in files:
            if nx.has_path(structure, node, file):
                score += size
        scores.append((node, score))

# Part 1
answer = list(filter(lambda x: x[1] < 100_000, scores))
# print(answer)
print(sum(list(map(lambda x: x[1], answer))))

print(total_size, scores[0][1])
# Part 2
space_free = 30_000_000 - (70_000_000 - scores[0][1])
print(space_free)
answer = sorted(list(filter(lambda x: x[1] > space_free, scores)), key=lambda x: x[1])
print(answer[0][1])


# Plotting the graph
from matplotlib import pyplot as plt
from networkx.drawing.nx_pydot import graphviz_layout
pos = nx.nx_agraph.pygraphviz_layout(structure, "dot")
nx.draw(structure, pos)
plt.show()