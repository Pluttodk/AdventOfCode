text = open("day2.txt","r")
lines = text.readlines()
resultStrings = []
perfect = ""
while(len(lines) > 0):
    name = lines.pop()
    result = ""
    for line in lines:
        closest = ""
        pos = 0
        for char in name:
            if(line[pos] == char):
                closest += char
            pos += 1
        if(len(closest) > len(result)):
            result = closest
    if(len(result) > len(perfect)):
        perfect = result
print perfect

# numberOfOccurencies = [0,0]

# for line in text:
#     chars = []
#     i = 0
#     hasReachTwice = False
#     hasReachThree = False
#     for char in line:
#         if char not in chars:
#             pos = line.count(char)
#             if pos == 2 and not hasReachTwice:
#                 numberOfOccurencies[0] += 1
#                 hasReachTwice = True
#             if (pos == 3) and not hasReachThree:
#                 numberOfOccurencies[1] += 1
#                 hasReachThree = True
#             chars.append(char)
# subtotal = 1
# for number in numberOfOccurencies:
#     if number > 0:
#         subtotal *= number
# print subtotal