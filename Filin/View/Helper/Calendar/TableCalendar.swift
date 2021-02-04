//
//  HabitCalendarTable.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct TableCalendar: View {
    
    let isExpanded: Bool
    @ObservedObject var habits: HabitGroup
    let selectedDate: Date
    let isEmojiView: Bool
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        if isExpanded {
            VStack(spacing: 8) {
                ForEach(
                    1...selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart),
                    id: \.self
                ) { week in
                    WeekTable(habits: habits, week: week, selectedDate: selectedDate, isEmojiView: isEmojiView)
                    if week != selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart) {
                        Divider()
                    }
                }
            }
        } else {
            WeekTable(
                habits: habits, week: selectedDate.weekNum(startFromMon: appSetting.isMondayStart),
                selectedDate: selectedDate, isEmojiView: isEmojiView
            )
        }
    }
    
    struct WeekTable: View {
        
        @ObservedObject var habits: HabitGroup
        let week: Int
        let selectedDate: Date
        let isEmojiView: Bool
        @EnvironmentObject var appSetting: AppSetting
        
        var targetDates: [Date] {
            selectedDate.daysInSameWeek(
                week: week,
                from: appSetting.isMondayStart ? 2 : 1
            )
        }
        
        @ViewBuilder
        func dot(date: Date, habit: FlHabit) -> some View {
            if isEmojiView {
                if habit.dailyEmoji[date.dictKey] != nil {
                    Text(habit.dailyEmoji[date.dictKey]!)
                        .font(.system(size: 16))
                        .frame(width: 20, height: 20)
                } else {
                    Circle()
                        .frame(width: 20, height: 20)
                        .inactiveColor()
                }
            } else {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(habit.color)
                    .opacity((habit.achievement.progress(at: date) ?? 0) + 0.1)
            }
        }
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text("\(targetDates.first?.localizedMonthDay ?? "")~\(targetDates.last?.localizedMonthDay ?? "")")
                        .subColor()
                        .bodyText()
                    Spacer()
                    ForEach(targetDates, id: \.dictKey) { date in
                        Text(Date.dayOfTheWeekShortEngStr(date.dayOfTheWeek))
                            .subColor()
                            .bodyText()
                            .frame(width: 20)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(habits.contents) { habit in
                            Text(habit.name)
                                .foregroundColor(habit.color)
                                .font(.custom("GodoB", size: 16))
                                .frame(height: 35)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        ForEach(habits.contents) { habit in
                            HStack {
                                ForEach(targetDates, id: \.dictKey) { date in
                                    dot(date: date, habit: habit)
                                    .frame(height: 35)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
