file = open("a.txt", 'r')
file_save = open("new.txt",'w')

temp_left = []
position_left = []
x_left = []
y_left = [] 

temp_right = []
position_right = []
x_right = []
y_right = [] 

temp_center = []
position_center = []
x_center = []
y_center = []





for line in  file:
    
    test = file.readline()
    
    (temp,x,y,zz) = line.split()

    if int(x) != -1 or int(y) != -1: # 검출되지 않은 동공 필터링 
       file_save.write(temp)
       file_save.write(" ")
       file_save.write(x)
       file_save.write(" ")
       file_save.write(y)
       file_save.write("\n")
       
        


file.close()
file_save.close()

