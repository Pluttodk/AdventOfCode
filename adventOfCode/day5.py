lines = open("day5test.txt", "r")
finalString = lines.readlines()
hasFoundSimilarities = False
while(not hasFoundSimilarities):
    for line in lines:
        skipNextChar = False
        previousChar = ""
        for i in range(0,len(line)-1):
            if(skipNextChar):
                continue
            nextChar = line[i+1]
            if(line[i].islower()):
                if (line[i].capitalize() == line[i+1]):

    hasFoundSimilarities = True