directions = list(map(lambda x: (x[0], int(x[1:])), open("2020/data/day12.txt").read().split("\n")))

east = 0.0
north = 0.0
rotation = 0

facing = ["E", "S", "W", "N"]
for way, distance in directions:
    if way == "F":
        location = (rotation % 360) // 90
        way = facing[location]
    if way == "N":
        north += distance
    elif way == "S":
        north -= distance
    elif way == "E":
        east += distance
    elif way == "W":
        east -= distance
    elif way == "R":
        rotation += distance
    elif way == "L":
        rotation -= distance
print(abs(east)+abs(north))


# PArt 2
east = 0.0
north = 0.0
rotation = 0

waypoint_e = 10
waypoint_n = 1

facing = ["E", "S", "W", "N"]
for way, distance in directions:
    if way == "F":
        east += waypoint_e*distance
        north += waypoint_n*distance
    if way == "N":
        waypoint_n += distance
    elif way == "S":
        waypoint_n -= distance
    elif way == "E":
        waypoint_e += distance
    elif way == "W":
        waypoint_e -= distance
    elif way == "L":
        if distance == 90:
            waypoint_e, waypoint_n = -waypoint_n, waypoint_e
        elif distance == 180:
            waypoint_e, waypoint_n = -waypoint_e, -waypoint_n
        elif distance == 270:
            waypoint_e, waypoint_n = waypoint_n, -waypoint_e
    elif way == "R":
        if distance == 90:
            waypoint_e, waypoint_n = waypoint_n, -waypoint_e
        elif distance == 180:
            waypoint_e, waypoint_n = -waypoint_e, -waypoint_n
        elif distance == 270:
            waypoint_e, waypoint_n = -waypoint_n, waypoint_e
print(abs(east)+abs(north))