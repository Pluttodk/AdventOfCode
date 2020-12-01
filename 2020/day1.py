# Made by Mathias Oliver Valdbjørn Jørgensen
# 01-12-2020
# TASK: Find if two numbers = 2020
#
# The task was first completed by using the part1() and part2()
# The faster methods are simply used to show how they can be done computationally faster
import numpy as np
import time

#For part 1
def part1():
    with open("2020/data/day1.txt", "r") as file:
        vals = list(map(int, file.readlines()))
        for i in range(len(vals)):
            for j in range(1,len(vals)):
                if vals[i] + vals[j] == 2020:
                    print(vals[i]*vals[j])
                    return

def part1_faster():
    with open("2020/data/day1.txt", "r") as file:
        vals = list(map(int, file.readlines()))
        vals = np.asarray(sorted(vals))
        l, u = 0, len(vals)-1
        while(l<u):
            if vals[l]+vals[u] == 2020:
                break
            elif (vals[l]+vals[u]) > 2020:
                u -= 1
            else:
                l += 1
        print(vals[l]*vals[u])

def part2():
    with open("2020/data/day1.txt", "r") as file:
        vals = list(map(int, file.readlines()))
        for i in range(len(vals)):
            for j in range(1,len(vals)):
                for k in range(2, len(vals)):
                    if vals[i] + vals[j] + vals[k] == 2020:
                        print(vals[i]*vals[j]*vals[k])
                        return
def part2_faster():
    with open("2020/data/day1.txt", "r") as file:
        vals = list(map(int, file.readlines()))
        vals = np.asarray(sorted(vals))
        l,m, u = 0,1, len(vals)-1
        def three_variable_search(l,m,u):
            while(m<u):
                if vals[l]+vals[m]+vals[u] == 2020:
                    break
                elif (vals[l]+vals[u]+vals[m]) > 2020:
                    u -= 1
                else:
                    m += 1
            return(l,m,u)
        while(vals[l]+vals[m]+vals[u] != 2020):
            l,m,u = three_variable_search(l,m,u)
            if m >= u:
                l += 1
                m = l+1
                u = len(vals)-1
        print(vals[l]*vals[m]*vals[u])
# part1()
# print("----------")
# part2()

part2_faster()
