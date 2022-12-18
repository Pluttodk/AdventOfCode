def getDate(line):
    return line.split("]")[0].split("[")[1]

guards = []
text = open ("day4.txt", "r")
values = text.readlines()
values.sort()
currentGuard = 0
startedSleeping = []
def updateGuard(name):
    for guard in guards:
        if(guard[0] == name[0]):
            middle = guard[1] + name[1]
            guards.remove(guard)
            guards.append((name[0],middle,name[2]))

def getGuard(name):
    for guard in guards:
        if(name == guard[0]):
            return guard
def containsGuard(name):
    for guard in guards:
        if(name == guard[0]):
            return True
    return False

for line in values:
    date = line.split("]")[0].split("[")[1]
    hour = date.split(" ")[1].split(":")
    date = date.split(" ")[0].split("-")
    
    quote = line.split("] ")[1]
    if quote.startswith("Guard "):
        number = int(quote.split(" begins shift")[0].split("Guard #")[1])
        currentGuard = number
    if quote.startswith("falls asleep"):
        startedSleeping = hour
    if quote.startswith("wakes up"):
        if currentGuard != 0:
            timeSpentSleeping = int(hour[1]) - int(startedSleeping[1])
            timeDif = []
            for c in range (int(startedSleeping[1]), int(hour[1])):
                timeDif.append(c)
            if(containsGuard(currentGuard)):
                timeSpentSleeping = timeSpentSleeping + getGuard(currentGuard)[2]
                guard = (currentGuard, timeDif, timeSpentSleeping)
                updateGuard(guard)
            else:
                guard = (currentGuard, timeDif, timeSpentSleeping)
                guards.append(guard)
    
bestGuard = guards[0]
mostAsleepGuard = bestGuard
mostASleepMinute = 0
mostASleepOccurencies = 0
bestMinute = 0
occurencies = 0
for guard in guards:
    bestMinute = 0
    occurencies = 0 
    minutes = guard[1]
    minutes.sort()
    for minute in minutes:
        number = minutes.count(minute)
        if(number > occurencies):
            bestMinute = minute
            occurencies = number
    if(mostASleepOccurencies < occurencies):
        mostAsleepGuard = guard
        mostASleepOccurencies = occurencies
        mostASleepMinute = bestMinute
    if(guard[2] > bestGuard[2]):
        bestGuard = guard
minutes = bestGuard[1]
minutes.sort()
for minute in minutes:
    number = minutes.count(minute)
    if(number > occurencies):
        bestMinute = minute
        occurencies = number
print mostAsleepGuard[0] * mostASleepMinute