packets = open("6.in", "r").read().split("\n")
# Set marker spacing
spacing = 14 if True else 4
for packet in packets:
    for i in range(len(packet)-spacing):
        if len(set(packet[i:i+spacing])) == spacing:
            print(i+spacing)
            break