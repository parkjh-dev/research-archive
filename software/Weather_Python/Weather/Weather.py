import requests # pip3 install requests
import datetime
import json
from Location import Location


class Weather(Location):
    log_file = None # 로깅 파일
    base_date = '' # 요청 날짜
    base_time = '' # 요청 시간

    # class 생성자
    def __init__(self,address):
        super().__init__(address)
        self.base_date = datetime.datetime.now().strftime("%Y%m%d") # 요청 날짜
        
        # 요청시간이 0시가 아니고 45분보다 작다면 
        if (int(datetime.datetime.now().strftime("%M")) < 45   and int(datetime.datetime.now().strftime("%H") != 0) ):
                self.base_time = str(int(datetime.datetime.now().strftime("%H")) - 1)+ "59" 
        else:
                self.base_time = datetime.datetime.now().strftime("%H%M") # 요청 시간

    # 날씨정보 로깅
    def loging(self, time, weather):
        self.log_file = open('/root/weather_log.txt','a')
        self.log_file.write('[' + time +'] ' + weather +'\n')

    # request data 생성 
    def set_request(self, location):
        body_data = {
            "ServiceKey" : 'zq/lxpoYLZqweyiNwlmEfwVQp95i+8r56s++trsdHA2IsMaZixp+yv+/P4SsJFhClqx2SobRXmrsxq8Hq4J+bA==',  # service_key
            "pageNo" : '1',
            "numOfRows" : '1000',
            "dataType" : 'JSON',
            "base_date" : self.base_date,
            "base_time" : self.base_time, 
            "nx" : location['x'], # x좌표
            "ny" : location['y'] # y좌표
        }
        return body_data
    

    def run(self):
        request_uri = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst' # 요청주소

        location = self.get_location() # x,y 위치정보 획득 
        request_data = self.set_request(location) # request 정보 획득
        
        # print(request_data) # Debug

        response = requests.get(request_uri, params=request_data) # response 정보 획득
        response=response.text 
        json_obj = json.loads(response)

        # print(json.dumps(json_obj, ensure_ascii=False, indent=3)) # response(Debug)

        sky_data = json_obj['response']['body']['items']['item']
        
        for i in sky_data:
            if (i['category'] == 'SKY'):
                # print(i['fcstTime']) # 예보시간(Debug)
                self.loging(datetime.datetime.now().strftime("%Y-%m-%d %H:%M"),self.weather_code(int(i['fcstValue'])))
                return int(i['fcstValue'])
    
    # 날씨 코드에 따른 날씨정보(1:맑음, 2:비, 3:구름, :4:흐림)
    def weather_code(self, number):
        weather_str = ['맑음', '비', '구름', '흐림']
        return weather_str[number-1]
    
    def __del__(self):
        self.log_file.close()
