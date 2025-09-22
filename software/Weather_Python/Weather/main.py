from Weather import Weather
import sys
import os

parameter = [] # 실행인자 저장 

# 파일명 포함 실행인자가 5개 이상이면 종료
if(len(sys.argv) >= 5): 
    exit(1)

# 파일명을 제외한 실행 인자를 리스트 형태로 저장
for i in range(1,len(sys.argv)):
    parameter.append(sys.argv[i])

# 인자가 3개라면 2번째와 3번째 결합
if(len(parameter) == 3):
    parameter[1] = parameter[1] + parameter[2]
    del parameter[2]    

Weather_obj = Weather(parameter)
result = Weather_obj.run()

if(result == 1):
    print(result)
    os.system("cp /var/www/html/image/weather/sun.png /var/www/html/image/img.png")
elif(result == 2):
    print(result)
    os.system("cp /var/www/html/image/weather/rain.png /var/www/html/image/img.png")
elif(result == 3):
    print(result)
    os.system("cp /var/www/html/image/weather/cloudy.png /var/www/html/image/img.png")
elif(result == 4):
    print(result)
    os.system("cp /var/www/html/image/weather/overcast.png /var/www/html/image/img.png")

    


# 00시에 대한 대비가 필요함.
