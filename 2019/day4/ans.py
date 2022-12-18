ran = "193651-649729"

def larger_group(v):
    return (v[0] == v[1] != v[2]) or (v[0] != v[1] == v[2] != v[3]) or (v[1] != v[2] == v[3] != v[4]) or (v[2] != v[3] == v[4] != v[5]) or(v[3] != v[4] == v[5])
        

def is_valid(value):
    #has double:
    has_double = False
    value = str(value)
    for i in range(1, len(value)):
        has_double = True if value[i] == value[i-1] else has_double
    is_increasing = True
    for i in range(1, len(value)):
        is_increasing = False if value[i] < value[i-1] else is_increasing
    return has_double and is_increasing and larger_group(value)
result = 0

#TEST
print(is_valid(112233))
print(is_valid(123444))
print(is_valid(111122))
print(is_valid(223450))
print(is_valid(123789))

for i in range(193651,649729):
    if (is_valid(i)):
        result +=1
print(result)