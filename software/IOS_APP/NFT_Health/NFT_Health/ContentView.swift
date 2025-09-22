import SwiftUI
import UserNotifications // 푸시알람 프레임워크

struct ContentView: View {
    let healthKitManager = HealthKitManager()
    
    @State private var totalRunningDistance: Double = 0
    @State private var Goal: String = ""
    @State private var Time = Date()
    @State private var isShowingAlert = false
    
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    var image_name = "fat"
    
    // UserDefaults에 사용자가 입력한 목표 KM를 저장하는 함수
    private func saveText()
    {
        defaults.set(Goal, forKey: "savedText")
    }
    
    // UserDefaults에서 사용자가 입력한 목표 KM를 불러오는 함수
    private func loadText() {
        if let savedText = defaults.string(forKey: "savedText") {
            Goal = savedText
        }
    }
    
    // UserDefaults에 사용자가 입력한 목표 날짜를 저장하는 함수
    private func saveDate()
    {
        dateFormatter.dateFormat = "a HH:mm"
        defaults.set(dateFormatter.string(from: Time), forKey: "savedDate")
    }
    
    // UserDefaults에서 사용자가 입력한 목표 날짜를 불러오는 함수
    private func loadDate()
    {
        dateFormatter.dateFormat = "a HH:mm"
        if let savedDate = defaults.string(forKey: "savedDate"), let date = dateFormatter.date(from: savedDate) {
            self.Time = date
        }
    }
    func startBackgroundTask() {
        DispatchQueue.global(qos: .background).async {
            //while true {
            //  print("Background task is running...\(Date())")
            //sleep(1) // 5초마다 실행
            //}
        }
    }
    var body: some View {
        var AppHelper = AppHelper()
        var DataSetting = DataSetting()
        Divider() // 구분선
        
        // 이미지
        VStack{
            Image(AppHelper.ConfirmImage(Goal, String(totalRunningDistance) ))
                .resizable()
                .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
        }
        
        // 오늘 걸은 거리 출력
        VStack {
            Text("Today's total running distance")
                .bold()
                .padding(.vertical, 5)
            Text("\(String(format: "%.2f", totalRunningDistance)) km")
            
        }
        .onAppear {
            healthKitManager.authorizeHealthKit { (success, error) in
                if success {
                    healthKitManager.fetchRunningDistanceData { (total, error) in
                        if let total = total {
                            DispatchQueue.main.async {
                                self.totalRunningDistance = total
                            }
                        }
                    }
                } else if let error = error {
                    print("Error while authorizing HealthKit: \(error.localizedDescription)")
                }
            }
        }
        .padding(.vertical, 5)
        
        Divider() // 구분선
        
        
        // 목표 설정
        VStack {
            Text("My Goal")
                .bold()
            
            // 거리
            HStack{
                Text("Distance")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                TextField("Enter KM here", text: $Goal, onEditingChanged: { _ in saveText()})
                    .multilineTextAlignment(.center)
                    .onAppear(perform: loadText)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("KM")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // 시간
            HStack{
                DatePicker(selection: $Time, displayedComponents: .hourAndMinute){
                    Text("Time")
                        .bold()
                }
                    .onAppear(perform: loadDate)
                    .onDisappear(perform: saveDate)
                    .padding(.horizontal, 60)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("")
                    .padding(.horizontal, 35)
            }
        }
        .padding(.vertical, 10)
        
        Divider() // 구분선
        
        // 달성까지 남은 거리
        VStack {
            Text("Remaining Goal")
                .bold()
                .padding(.vertical, 5)
            
            Text("\(AppHelper.ConfirmGoal(Goal, String(totalRunningDistance) ))")
            
        }
        .padding(.vertical, 5)
        
        Divider() // 구분선
        
        // 저장 버튼
        VStack {
            
            Button(action: {
                AppHelper.alert(Time,"목표 달성 확인","오늘 하루 목표에 달성하였는지 확인해보세요 !") // Test
                print(Time)
                saveText()
                saveDate()
                isShowingAlert = true
                startBackgroundTask()
                
            }){
                Text("Save")
                    .padding()
                    .frame(width: 130, height: 45)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    
            }
            .accentColor(.black)
            
        }.alert(isPresented: $isShowingAlert, content: {
            Alert(title: Text("설정 완료"), message: Text("입력한 내용이 저장되었습니다."), dismissButton: .default(Text("확인")))
        })
        .padding(.vertical, 5)
        
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
