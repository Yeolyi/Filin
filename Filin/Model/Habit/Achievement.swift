//
//  Achievement.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

struct Achievement {
    
    typealias DateKey = String
    
    var content: [DateKey: Int]
    var numberOfTimes: Int
    var addUnit: Int
    
    init(_ content: [DateKey: Int] = [:], numberOfTimes: Int, addUnit: Int = 1) {
        self.content = content
        self.numberOfTimes = numberOfTimes
        self.addUnit = addUnit
    }
    
    func isDone(at date: Date) -> Bool {
        let currentAmount = content[date.dictKey] ?? 0
        return numberOfTimes <= currentAmount
    }
    
    func progress(at date: Date) -> Double? {
        guard let achievement = content[date.dictKey] else {
            return nil
        }
        return Double(achievement)/Double(numberOfTimes)
    }
    
    mutating func set(at date: Date, using closure: (_ val: Int, _ addUnit: Int) -> Int) {
        content[date.dictKey] = closure((content[date.dictKey] ?? 0), addUnit)
    }
    
    mutating func setWithOptional(at date: Date, using closure: (_ val: Int?, _ addUnit: Int) -> Int) {
        content[date.dictKey] = closure(content[date.dictKey], addUnit)
    }
}

extension Date {
    var dictKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    init(dictKey: String) {
        let split = dictKey.split(separator: "-").map {Int($0)!}
        var dayComponent = DateComponents()
        dayComponent.year = split[0]
        dayComponent.month = split[1]
        dayComponent.day = split[2]
        let calendar = Calendar.current
        self = calendar.date(from: dayComponent)!
    }
}
