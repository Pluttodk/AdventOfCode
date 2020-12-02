import matplotlib.pyplot as plt
import numpy as np
import time

with open("2020/data/day1.txt", "r") as file:
    vals = list(map(int, file.readlines()))
    vals = np.asarray(sorted(vals))
    l, u = 0, len(vals)-1
    # fig = plt.figure()
    # ax = fig.add_subplot(111)
    x = np.concatenate([vals[:l], vals[u:]])
    plt.ion()
    while(l<u):
        y = np.zeros(len(x))
        zeros = vals[l+1:u]
        y = np.concatenate([vals[:l+1], np.zeros(len(zeros)), vals[u:]])
        if vals[l]+vals[u] == 2020:
            plt.bar(np.arange(len(y)),y)
            plt.bar([l,u],[vals[l],vals[u]], width=10, color="green")
            plt.draw()
            plt.pause(10)
            plt.clf()
            break
        elif (vals[l]+vals[u]) > 2020:
            u -= 1
        else:
            l += 1
        plt.bar(np.arange(len(y)),y)
        plt.draw()
        plt.pause(0.00001)
        plt.clf()
        # fig.canvas.draw()
        # fig.canvas.flush_events()