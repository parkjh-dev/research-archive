import pandas as pd 
# pip3 install -y pandas
# pip3 install openpyxl

class Location:
    location = {} # 딕셔너리 형태로 x,y 좌표를 출력함.
    address = [] # 사용자가 입력한 주소

    def __init__(self,address):
        self.address = address

    def get_file(self):
        # 읽어올 엑셀 파일 지정
        filename = '/root/python/Weather/Location.xlsx'
        # 엑셀 파일 읽어 오기
        xlsx_data = pd.read_excel(filename, engine='openpyxl')

        return xlsx_data
        
        

    def get_location(self):

        xlsx_data = self.get_file()
        
        filter_data = xlsx_data[(xlsx_data['1단계']==self.address[0]) & (xlsx_data['2단계']==self.address[1]) & (xlsx_data['3단계'].isnull())]

        location_x = filter_data['격자 X'].values[0]
        location_y = filter_data['격자 Y'].values[0]
                
        self.location={'x':location_x, 'y':location_y}

        return self.location
