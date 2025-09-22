//
//  AppHelper.swift
//  NFT_Health
//
//  Created by 박지환 on 2023/02/26.
//

import Foundation
import UserNotifications // 푸시알람 프레임워크


class AppHelper {
    
    
    public func ConfirmGoal(_ goal: String, _ now: String) -> String
    {
        guard let goalValue = Double(goal), let nowValue = Double(now) else {
            return "Invalid input"
        }
        var result = goalValue - nowValue
        result = round(result * 100) / 100 // 소수점 2자리까지
        if result > 0.0{
            return "\(String(result)) KM left to the goal."
        }else{
            return "Goal achieved."
        }
    }
    
    
    public func ConfirmImage(_ goal: String, _ now: String) -> String
    {
        guard let goalValue = Double(goal), let nowValue = Double(now) else {
            return "fat"
        }
        var result = goalValue - nowValue
        result = round(result * 100) / 100 // 소수점 2자리까지
        if result >= 0.0{
            return "fat"
        }else{
            return "skinny"
        }
    }
    
    
    public func alert(_ time: Date, _ title: String, _ body:String) {
        // 알림 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        //print(time)
        // 알림 트리거 생성
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time), repeats: true)
       

        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: "GoalNotification", content: content, trigger: trigger)
       
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else if granted {
                print("알림 권한 요청 성공!")
                center.add(request) { (error) in
                    if let error = error {
                        print("알림 등록 실패: \(error.localizedDescription)")
                    } else {
                        print("알림 등록 성공!\(Date())")
                    }
                }
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    
}

