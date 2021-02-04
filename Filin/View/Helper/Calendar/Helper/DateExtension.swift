//
//  DateProvider.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import Foundation

extension Date {
    
    /// self가 몇번째 주인지 반환
    func weekNum(startFromMon: Bool) -> Int {
        if startFromMon && self.dayOfTheWeek == 1 {
            return Calendar.current.component(.weekOfMonth, from: self) - 1
        } else {
            return Calendar.current.component(.weekOfMonth, from: self)
        }
    }
    
    /// self가 속한 달에 존재하는 주의 수.
    /// - Parameter startFromMon: 한 주가 월요일부터 시작하도록 세팅되어있으면 true.
    func weekNuminMonth(isMondayStart: Bool) -> Int {
        let calendar = Calendar.current
        let weekRange = calendar.range(
            of: .weekOfMonth,
            in: .month,
            for: self
        )!
        return weekRange.count - (isMondayStart && lastDayOfWeekOfMonth == 1 ? 1 : 0)
    }
    
    /// 한 달에 포함된 날의 개수.
    var monthLength: Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    var firstDayOfWeekOfMonth: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: self)
        dateComponents.day = 1
        return calendar.date(from: dateComponents)!.dayOfTheWeek
    }
    var lastDayOfWeekOfMonth: Int {
        let calendar = Calendar.current
        var dateComponents  = calendar.dateComponents([.year, .month], from: self)
        dateComponents.day = calendar.range(of: .day, in: .month, for: self)?.count
        return calendar.date(from: dateComponents)!.dayOfTheWeek
    }
    
    var firstDayOfMonth: Date {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func addDate(_ num: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = num
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: self)
    }
    func addMonth(_ num: Int) -> Date {
        var dayComponent = DateComponents()
        dayComponent.month = num
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: self)!
    }
    
    func nearDayOfWeekDate(_ dayOfWeeks: [Int]) -> Date {
        var dateIterate = self
        while !dayOfWeeks.contains(dateIterate.dayOfTheWeek) {
            var dayComponent = DateComponents()
            dayComponent.day = 1
            let theCalendar = Calendar.current
            dateIterate = theCalendar.date(byAdding: dayComponent, to: dateIterate)!
        }
        return dateIterate
    }
    
    func monthShift(contains dayOfWeek: [Int], isAdd: Bool) -> Date {
        var plusCursor = Calendar.current.date(
            byAdding: .month, value: isAdd ? 1 : -1, to: self
        )!
        var minusCursor = plusCursor
        var plusCount = 0
        var minusCount = 0
        while dayOfWeek.contains(plusCursor.dayOfTheWeek) == false {
            plusCursor = plusCursor.addDate(1)!
            plusCount += 1
        }
        while dayOfWeek.contains(minusCursor.dayOfTheWeek) == false {
            minusCursor = minusCursor.addDate(-1)!
            minusCount += 1
        }
        let calendar = Calendar.current
        if calendar.dateComponents([.month], from: self, to: plusCursor).month ?? 10 >= 2 {
            return minusCursor
        }
        if calendar.dateComponents([.month], from: self, to: minusCursor).month ?? 10 >= 2 {
            return plusCursor
        }
        return plusCount > minusCount ? minusCursor : plusCursor
    }
    
    /// Self를 포함하는 달의 특정 주에 포함되는 Date 배열을 반환합니다.
    /// - Parameters:
    ///   - baseDayOfWeek: 시작 날짜의 요일을 설정합니다. 1은 일요일, 7은 토요일을 의미합니다.
    func daysInSameWeek(week: Int, from baseDayOfWeek: Int = 1) -> [Date] {
        var tempDateList: [Date] = []
        let firstDayOfWeek = self.firstDayOfWeekOfMonth
        
        for diff in baseDayOfWeek - firstDayOfWeek ..< baseDayOfWeek + 7 - firstDayOfWeek {
            let newDate = Calendar.current.date(
                byAdding: .day,
                value: diff + 7 * (week - 1),
                to: self.firstDayOfMonth
            )!
            tempDateList.append(newDate)
        }
        return tempDateList
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
    var dayOfTheWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
