//
//  ViewController.swift
//  NFT_Health
//
//  Created by 박지환 on 2023/02/20.
//

import Foundation



import UIKit
import HealthKit

class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    let healthStore = HKHealthStore()
    let typeToShare:HKCategoryType? = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
    let typeToRead:HKSampleType? = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
    var sleepData:[HKCategorySample] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveSleepData()
        configure()
    }
    
    func configure() {
        
        if !HKHealthStore.isHealthDataAvailable() {
            requestAuthorization()
        }else {
            retrieveSleepData()
        }
    }
    // 권한 획득
    func requestAuthorization() {
        
        self.healthStore.requestAuthorization(toShare: Set([typeToShare!]), read: Set([typeToRead!])) { success, error in
            if error != nil {
                print(error.debugDescription)
            }else{
                if success {
                    print("권한이 허락되었습니다.")
                }else{
                    print("권한이 아직 없어요.")
                }
            }
        }
    }
    
    func retrieveSleepData() {
        let start = makeStringToDate(str: "2021-04-03")
        let end = Date()
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: typeToRead!, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { [weak self] (query, sleepResult, error) -> Void in

            if error != nil {
                return
            }
            
            if let result = sleepResult {
                DispatchQueue.main.async {
                    //수면 데이터에 받아온 데이터를 설정해줌.
                    self?.sleepData = result as? [HKCategorySample] ?? []
                    self?.table.reloadData()
                }
            }
        }
        healthStore.execute(query)
    }
    
    func saveSleepData() {
        let start = makeStringToDateWithTime(str: "2021-04-03 10:00")
        let end = makeStringToDateWithTime(str: "2021-07-05 11:00")
        let object = HKCategorySample(type: typeToShare!, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: start,end: end)
        healthStore.save(object, withCompletion: { (success, error) -> Void in
            if error != nil {
                return
            }
            if success {
                print("수면 데이터 저장 완료!")
                self.retrieveSleepData()
            } else {
                print("수면 데이터 저장 실패...")
            }
        })
    }
    
    func makeStringToDate(str:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        return dateFormatter.date(from: str)!
    }
    
    func makeStringToDateWithTime(str:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")

        return dateFormatter.date(from: str)!
    }
    
    func dateToString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

       return dateFormatter.string(from: date)
    }
    
    func dateToStringOnlyTime(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

       return dateFormatter.string(from: date)
    }
    
}


extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sleep = sleepData[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let date = dateToString(date: sleep.startDate)
        let start = dateToStringOnlyTime(date: sleep.startDate)
        let end = dateToStringOnlyTime(date: sleep.endDate)
      
        cell.textLabel?.text = "\(date): \(start)부터 ~ \(end)까지 잤네요."
        
        return cell
    }
}
