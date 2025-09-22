//
//  UserSetting.swift
//  NFT_Health
//
//  Created by 박지환 on 2023/02/26.
//
import SwiftUI
import Foundation

class DataSetting{
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    
    @State public var Goal: String = ""
     public var Time = Date()
    
    // UserDefaults에 사용자가 입력 한 목표 KM를 저장하는 함수
    public func saveText()
    {
        self.defaults.set(self.Goal, forKey: "savedText")
    }
    
    // UserDefaults에서 사용자가 입력한 목표 KM를 불러오는 함수
    public func loadText() {
        if let savedText = self.defaults.string(forKey: "savedText") {
            self.Goal = savedText
        }
    }
    
    // UserDefaults에 사용자가 입력한 목표 날짜를 저장하는 함수
    public func saveDate()
    {
        self.dateFormatter.dateFormat = "a HH:mm"
        self.defaults.set(self.dateFormatter.string(from: self.Time), forKey: "savedDate")
    }
    
    // UserDefaults에서 사용자가 입력한 목표 날짜를 불러오는 함수
    public func loadDate()
    {
        dateFormatter.dateFormat = "a HH:mm"
        if let savedDate = defaults.string(forKey: "savedDate"), let date = self.dateFormatter.date(from: savedDate) {
            self.Time = date
        }
    }
}
