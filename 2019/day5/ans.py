import sys


inp = sys.stdin.readline()
val = [int(i) for i in inp.split(",")]
i = 0
while(val[i] != 99):
    fst, snd, thd = val[i+1], val[i+2], val[i+3]
    
    #VAl is made up as 1 1 1 02
    #fst_op = val[-3]
    #snd_op = val[-4]
    #thd_op = val[0]
    instruct = str(val[i])
    op = int(instruct[-2:])

    fst_op = 0 if len(instruct) < 3 else int(instruct[-3])
    snd_op = 0 if len(instruct) < 4 else int(instruct[-4])
    thd_op = 0 if len(instruct) < 5 else int(instruct[-5])
    print(val[i:i+10])
    print(op)
    fst_val = fst if fst_op == 1 else val[fst]
    if(op == 1):
        snd_val = snd if snd_op == 1 else val[snd]
        
        if thd_op != 1:
            val[thd] = fst_val + snd_val
        else:
            val[i+3] = fst_val + snd_val
        i+=4
    elif(op == 2):
        snd_val = snd if snd_op == 1 else val[snd]
        
        if thd_op != 1:
            val[thd] = fst_val * snd_val
        else:
            val[i+3] = fst_val * snd_val
        i+=4
    elif(op == 5):
        if val[i+1] != 0:
            i = val[i+2]
    elif(op == 6):
        if val[i+1] == 0:
            i = val[i+2]
    elif(op == 7):
        if thd_op != 1:
            val[thd] = int(vals[i+1] < vals[i+2])
        else:
            val[i+3] = int(vals[i+1] < vals[i+2])
        i+=4
    elif(op == 8):
        if thd_op != 1:
            val[thd] = int(vals[i+1] < vals[i+2])
        else:
            val[i+3] = int(vals[i+1] < vals[i+2])
        i+=4        
    elif(op == 3):
        # input the value at 2
        res = 5
        val[fst] = int(res)
        # Increase pointer by 2
        i+=2
    elif(op == 4):
        # output the value at pos 50
        # Increase pointer by 2  
        print(val[fst])
        i+=2
    else:
        assert False
    
if(val[0] == 19690720):
    print(f"Val reached {val[0]} for noun: {noun} and verb: {verb}")