import sys


inp = sys.stdin.readline()
for noun in range(0,100):
    for verb in range(0,100):

        val = [int(i) for i in inp.split(",")]
        val[1] = noun
        val[2] = verb

        i = 0
        while(val[i] == 1 or val[i] == 2):
            fst, snd, thd = val[i+1], val[i+2], val[i+3]
            if(val[i] == 1):
                val[thd] = val[fst] + val[snd]
            elif(val[i] == 2):
                val[thd] = val[fst] * val[snd]
            else:
                print(i)
            i+=4
        if(val[0] == 19690720):
            print(f"Val reached {val[0]} for noun: {noun} and verb: {verb}")