//
//  HabitStatisticsExtension.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI

// 설정의 초기화 시간을 준수하도록 수정해야함!!
extension FlHabit {
    
    var firstDay: Date? {
        if let firstDayKey = Array(achievement.content.keys).sorted(by: <).first {
            return Date(dictKey: firstDayKey)
        } else {
            return nil
        }
    }
    
    /// 최근 100일간의 달성량 평균 반환
    ///
    /// - Note: 기록 일수가 100일 미만이면 존재하는 기록만의 평균을 반환
    var longTermAvg: Double {
        guard let firstDay = firstDay else { return 0 }
        let yearAchievement: [Int] = achievement.content.compactMap {
            let diff = Date(dictKey: $0.key).diffToToday
            return (diff <= 100 && diff >= 1) ? $0.value : nil
        }
        return Double(yearAchievement.reduce(0, +)) / Double(max(1, firstDay.diffToToday))
    }
    
    /// 목표 시작 시기와 무관하게 최근 7일간의 평균값 반환
    func recentWeekAvg() -> Double {
        let recentWeekAchieve =
            Array((-7)...(-1)).map({Date().addDate($0)!}).map({achievement.content[$0.dictKey] ?? 0 })
        return Double(recentWeekAchieve.reduce(0, +)) / Double(recentWeekAchieve.count)
    }
    
    /// 목표 시작 시기와 무관하게 최근 한 달간의 평균값 반환
    /// - Note: 한 달의 기준은 month 값에서 1을 뺀 기간.
    func recentMonthAvg() -> Double {
        let oneMonthDiff = Date().addMonth(-1).diffToToday
        let recentWeekAchieve =
            Array((-oneMonthDiff)...(-1)).map({Date().addDate($0)!}).map({achievement.content[$0.dictKey] ?? 0 })
        return Double(recentWeekAchieve.reduce(0, +)) / Double(recentWeekAchieve.count)
    }
}

extension FlHabit {
    
    /// longTermAvg와 같은 기간동안의 요일별 달성량 반환
    ///
    /// - Note: 기록 일수가 100일 미만이면 존재하는 기록만의 달성량을 반환
    private var dayOfWeekAchievement: [Int] {
        guard firstDay != nil else {
            return [Int](repeating: 0, count: 7)
        }
        return achievement.content.reduce(into: [Int](repeating: 0, count: 7)) { result, dailyAchievement in
            let date = Date(dictKey: dailyAchievement.key)
            let diff = date.diffToToday
            guard diff <= 100 && diff >= 1 else { return }
            result[date.dayOfTheWeek - 1] += dailyAchievement.value
        }
    }
    
    /// longTermAvg와 같은 기간동안의 요일별 평균 반환
    var dayOfWeekAvg: [Double] {
        guard let firstDay = firstDay, firstDay.dictKey != Date().dictKey else {
            return [Double](repeating: 0, count: 7)
        }
        let usableDayCount = min(100, firstDay.diffToToday)
        let dayOfWeekCount = Array(((-usableDayCount)...(-1))).map({Date().addDate($0)!})
            .reduce(into: [Int](repeating: 0, count: 7)) { result, date in
                result[date.dayOfTheWeek - 1] += 1
            }
        let val: [Double] = dayOfWeekAchievement.enumerated().map { index, value in
            guard dayOfWeekCount[index] != 0 else { return 0 }
            return Double(value) / Double(dayOfWeekCount[index])
        }
        return val
    }
    
    var weeklyTrend: Double? {
        guard let firstDay = firstDay, firstDay.diffToToday >= 7 else {
            return nil
        }
        return recentWeekAvg() - longTermAvg
    }
    
    var monthlyTrend: Double? {
        let lastMonth = Date().addMonth(-1)
        let requiredDays = lastMonth.diffToToday
        guard let firstDay = firstDay, firstDay.diffToToday >= requiredDays else {
            return nil
        }
        return recentMonthAvg() - longTermAvg
    }
    
    var dayOfWeekTrend: [Double] {
        let lastWeekAchievement = Array((-7)...(-1)).reduce(into: [Int](repeating: 0, count: 7)) { result, value in
            let date = Date().addDate(value)!
            result[date.dayOfTheWeek - 1] = achievement.content[date.dictKey] ?? 0
        }
        let dayOfWeekAvg = self.dayOfWeekAvg
        return lastWeekAchievement.enumerated().map { index, value in
            Double(value) - dayOfWeekAvg[index]
        }
    }
    
    var continousAchievementCount: Int {
        guard let firstDay = firstDay, firstDay.dictKey != Date().dictKey else { return 0 }
        let firstDayDiff = min(100, max(1, firstDay.diffToToday))
        let boolAchievement = Array((-firstDayDiff)...(-1)).map({Date().addDate($0)!.dictKey}).map {
            achievement.content[$0] == nil ? false : true
        }
        var max = 0
        var count = 0
        for isValue in boolAchievement {
            if isValue { count += 1 } else { count = 0 }
            if max < count { max = count }
        }
        return max
    }
    
    var continousInachievementCount: Int {
        guard let firstDay = firstDay, firstDay.dictKey != Date().dictKey else { return 0 }
        let firstDayDiff = min(100, max(1, firstDay.diffToToday))
        let boolAchievement = Array((-firstDayDiff)...(-1)).map({Date().addDate($0)!.dictKey}).map {
            achievement.content[$0] == nil ? true : false
        }
        var max = 0
        var count = 0
        for isValue in boolAchievement {
            if isValue { count += 1 } else { count = 0 }
            if max < count { max = count }
        }
        return max
    }
    
}

extension Date {
    var diffToToday: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
}
