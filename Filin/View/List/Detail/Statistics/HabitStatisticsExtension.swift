//
//  HabitStatisticsExtension.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI

extension FlHabit {
    
    var firstDayKeyStr: String {
        Array(achievement.content.keys).sorted(by: <).first ?? Date().dictKey
    }
    
    var firstDay: Date {
        Date(dictKey: firstDayKeyStr)
    }

    var yearAverage: Double {
        let yearAchievement = achievement.content.filter {
            let dateFromtoday = Date(dictKey: $0.key).daysFromToday
            return dateFromtoday <= 100 && dateFromtoday > 0
        }
        return
            yearAchievement.reduce(0, {$0 + Double($1.value)})
            / max(1, min(Double(abs(firstDay.daysFromToday)), 100))
    }
    
    func weeklyAverage(at date: Date) -> Double {
        var weekList: [Date] = []
        for i in -7 ... -1 {
            weekList.append(date.addDate(i)!)
        }
        let achievementList = weekList.compactMap { date in
            self.achievement.content[date.dictKey] ?? 0
        }
        guard !achievementList.isEmpty else {
            return 0
        }
        return Double(achievementList.reduce(0, {$0 + Int($1)}))/7
    }
    
    func monthlyAverage(at date: Date) -> Double {
        var weekList: [Date] = []
        var datePointer = date.addDate(-1)!
        let targetDateKey = date.addMonth(-1).dictKey
        while datePointer.dictKey != targetDateKey {
            weekList.append(datePointer)
            datePointer = datePointer.addDate(-1)!
        }
        let achievementList = weekList.compactMap { date in
            self.achievement.content[date.dictKey] ?? 0
        }
        guard !achievementList.isEmpty else {
            return 0
        }
        return Double(achievementList.reduce(0, {$0 + Int($1)}))
            / Double(Calendar.current.dateComponents([.day], from: datePointer, to: date).day!)
    }
}

extension FlHabit {
    var dayOfWeekAchievement: [Int] {
        var temp = [Int](repeating: 0, count: 7)
        let achievementFiltered = achievement.content.filter {
            let dateFromtoday = Date(dictKey: $0.key).daysFromToday
            return dateFromtoday < 100 && dateFromtoday > 0
        }
        for (dictKey, value) in achievementFiltered {
            let date = Date(dictKey: dictKey)
            let dayOfWeekIndex = date.dayOfTheWeek - 1
            temp[dayOfWeekIndex] += Int(value)
        }
        return temp
    }
    var dayOfWeekAverage: [Double] {
        var count = [Int]()
        if firstDay.daysFromToday < 100 {
            count = [Int](repeating: 0, count: 7)
            var datePointer = firstDay
            while datePointer.dictKey != Date().dictKey {
                count[datePointer.dayOfTheWeek - 1] += 1
                datePointer = datePointer.addDate(1)!
            }
            count[datePointer.dayOfTheWeek - 1] += 1
        } else {
            count = [Int](repeating: 14, count: 7)
            let firstDayofWeekIndex = firstDay.dayOfTheWeek
            print(firstDayofWeekIndex)
            count[firstDayofWeekIndex + 1 > 6 ? 0 : firstDayofWeekIndex + 1] += 1
            count[firstDayofWeekIndex + 2 > 6 ? firstDayofWeekIndex - 5 : firstDayofWeekIndex + 2] += 1
        }
        return dayOfWeekAchievement.enumerated().map { Double($1)/Double(max(1, count[$0])) }
    }
}

extension Date {
    var daysFromToday: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
}
