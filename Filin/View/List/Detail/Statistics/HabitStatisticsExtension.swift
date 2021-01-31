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
    func longTermAvg(_ date: Date) -> Double {
        guard let firstDay = firstDay else { return 0 }
        let yearAchievement: [Int] = achievement.content.compactMap {
            let diff = Date(dictKey: $0.key).diffToSettingDate(date)
            return (diff <= 100 && diff >= 1) ? $0.value : nil
        }
        return Double(yearAchievement.reduce(0, +)) / Double(max(1, firstDay.diffToSettingDate(date)))
    }
    
    /// 목표 시작 시기와 무관하게 최근 7일간의 평균값 반환
    func recentWeekAvg(_ mainDate: Date) -> Double {
        let recentWeekAchieve =
            Array((-7)...(-1)).map({mainDate.addDate($0)!}).map({achievement.content[$0.dictKey] ?? 0 })
        return Double(recentWeekAchieve.reduce(0, +)) / Double(recentWeekAchieve.count)
    }
    
    /// 목표 시작 시기와 무관하게 최근 한 달간의 평균값 반환
    /// - Note: 한 달의 기준은 month 값에서 1을 뺀 기간.
    func recentMonthAvg(_ mainDate: Date) -> Double {
        let oneMonthDiff = mainDate.addMonth(-1).diffToSettingDate(mainDate)
        let recentWeekAchieve =
            Array((-oneMonthDiff)...(-1)).map({mainDate.addDate($0)!}).map({achievement.content[$0.dictKey] ?? 0 })
        return Double(recentWeekAchieve.reduce(0, +)) / Double(recentWeekAchieve.count)
    }
}

extension FlHabit {
    
    /// longTermAvg와 같은 기간동안의 요일별 달성량 반환
    ///
    /// - Note: 기록 일수가 100일 미만이면 존재하는 기록만의 달성량을 반환
    private func dayOfWeekAchievement(_ mainDate: Date) -> [Int] {
        guard firstDay != nil else {
            return [Int](repeating: 0, count: 7)
        }
        return achievement.content.reduce(into: [Int](repeating: 0, count: 7)) { result, dailyAchievement in
            let date = Date(dictKey: dailyAchievement.key)
            let diff = date.diffToSettingDate(mainDate)
            guard diff <= 100 && diff >= 1 else { return }
            result[date.dayOfTheWeek - 1] += dailyAchievement.value
        }
    }
    
    /// longTermAvg와 같은 기간동안의 요일별 평균 반환
    func dayOfWeekAvg(_ mainDate: Date) -> [Double] {
        guard let firstDay = firstDay, firstDay.dictKey != mainDate.dictKey else {
            return [Double](repeating: 0, count: 7)
        }
        let usableDayCount = min(100, firstDay.diffToSettingDate(mainDate))
        let dayOfWeekCount = Array(((-usableDayCount)...(-1))).map({mainDate.addDate($0)!})
            .reduce(into: [Int](repeating: 0, count: 7)) { result, date in
                result[date.dayOfTheWeek - 1] += 1
            }
        let val: [Double] = dayOfWeekAchievement(mainDate).enumerated().map { index, value in
            guard dayOfWeekCount[index] != 0 else { return 0 }
            return Double(value) / Double(dayOfWeekCount[index])
        }
        return val
    }
    
    func weeklyTrend(mainDate: Date) -> Double? {
        guard let firstDay = firstDay, firstDay.diffToSettingDate(mainDate) >= 7 else {
            return nil
        }
        return recentWeekAvg(mainDate) - longTermAvg(mainDate)
    }
    
    func monthlyTrend(mainDate: Date) -> Double? {
        let lastMonth = mainDate.addMonth(-1)
        let requiredDays = lastMonth.diffToSettingDate(mainDate)
        guard let firstDay = firstDay, firstDay.diffToSettingDate(mainDate) >= requiredDays else {
            return nil
        }
        return recentMonthAvg(mainDate) - longTermAvg(mainDate)
    }
    
    func dayOfWeekTrend(settingDate: Date) -> [Double] {
        dayOfWeekAvg(settingDate).map {
            $0 - longTermAvg(settingDate)
        }
    }
    
    func continousAchievementCount(_ mainDate: Date) -> Int {
        guard let firstDay = firstDay, firstDay.dictKey != mainDate.dictKey else { return 0 }
        let firstDayDiff = min(100, max(1, firstDay.diffToSettingDate(mainDate)))
        let boolAchievement = Array((-firstDayDiff)...(-1)).map({mainDate.addDate($0)!.dictKey}).map {
            (achievement.content[$0] ?? 0) >= achievement.numberOfTimes ? true : false
        }
        var max = 0
        var count = 0
        for isValue in boolAchievement {
            if isValue { count += 1 } else { count = 0 }
            if max < count { max = count }
        }
        return max
    }
    
    func continousInachievementCount(_ mainDate: Date) -> Int {
        guard let firstDay = firstDay, firstDay.dictKey != mainDate.dictKey else { return 0 }
        let firstDayDiff = min(100, max(1, firstDay.diffToSettingDate(mainDate)))
        let boolAchievement = Array((-firstDayDiff)...(-1)).map({mainDate.addDate($0)!.dictKey}).map {
            (achievement.content[$0] == nil || achievement.content[$0] == 0) ? true : false
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
    
    func diffToSettingDate(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: date).day!
    }

}
