pairs = open("4.in", "r").read().split("\n")

full_overlap = 0
overlap = 0
vals = []
for pair in pairs:
    sections = pair.replace(",","-").split("-")
    l1,h1,l2,h2 = list(map(int, sections))
    vals.append([l1,h1,l2,h2])
    if (l2 <= l1 and h2 >= h1) or (l1 <= l2 and h1 >= h2):
        full_overlap +=1
    if len(set(range(l1,h1+1)).intersection(set(range(l2,h2+1)))):
        overlap += 1
print("Part 1: ", full_overlap)
print("Part 2: ", overlap)

def plot_data():
    from matplotlib import pyplot as plt
    from matplotlib.animation import FuncAnimation
    import numpy as np
    plt.style.use('seaborn-pastel')

    y_max = max(map(lambda x: max([x[1],x[3]]), vals))
    y_min = min(map(lambda x: min([x[0],x[2]]), vals))
    print(y_max, y_min)

    fig = plt.figure()

    ax = plt.axes(xlim=(0, 5), ylim=(y_min, y_max))
    line1, = ax.plot([], [], lw=3, label="First section")
    line2, = ax.plot([], [], lw=3, label="Second section")
    line3, = ax.plot([],[], lw=10, label="Intersection")

    def init():
        line1.set_data([], [])
        line2.set_data([], [])
        line3.set_data([],[])
        return line1, line2,line3

    def animate(i):
        l1,h1,l2,h2 = vals[i]
        answer = set(range(l1,h1+1)).intersection(set(range(l2,h2+1)))
        line1.set_data([1,1], [l1,h1])
        line2.set_data([4,4], [l2,h2])
        if len(answer):
            line3.set_data([2,2], [min(answer), max(answer)])
        else:
            line3.set_data([],[])
        plt.title(f"Elf {i}")
        return line1,line2,line3

    anim = FuncAnimation(fig, animate, init_func=init,
                                frames=200, interval=200, blit=True)
    anim.save('coil.gif',writer='imagemagick') 
plot_data()
