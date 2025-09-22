#개발한 기기 데이터
# 병원데이터

import math
h_x = [2,63,79,103,112,131,176,213,229,239,267,304,322,335,346]
h_y = [245,236,239,240,244,246,240,239,240,244,245,240,241,244,248]


l_x = [58,71,101,106,125,171,202,224,236,261,302,316,329,324]
l_y = [232,234,234,238,240,236,235,236,238,240,236,237,239,242]



i = 0
lens = 0
lenss = 0

# 길이
while i < 14:
    
   # print(i)
    
    lens = lens+(math.sqrt(pow(l_x[i] - h_x[i],2) + pow(l_y[i] - h_y[i],2)))
    lenss = lenss+(math.sqrt(pow(l_x[i] - h_x[i+1],2) + pow(l_y[i] - h_y[i+1],2)))
    i+=1

print(lens/14)
print(lenss/14)
print("\n")







# 기울기

gradient_one = 0
gradient_two = 0
k = 0
while k < 14:
    gradient_one += abs((l_y[k] - h_y[k])) / abs((l_x[k] - h_x[k]))

    if k != 13:
        gradient_two += abs((l_y[k] - h_y[k+1])) / abs((l_x[k] - h_x[k+1])) 
        print(gradient_two)
    k+=1

print(gradient_one/14)

print(gradient_two/12)


