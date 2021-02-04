//
//  RingsCalendar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/10.
//

import SwiftUI

struct HabitCalendar: View {
    
    @Binding var selectedDate: Date
    @Binding var isEmojiView: Bool
    @Binding var isExpanded: Bool
    @ObservedObject var habits: HabitGroup
    
    let isCapture: Bool
    
    init(
        selectedDate: Binding<Date>, isEmojiView: Binding<Bool>,
        isExpanded: Binding<Bool>, habits: HabitGroup, isCapture: Bool = false
    ) {
        self._selectedDate = selectedDate
        self._isEmojiView = isEmojiView
        self._isExpanded = isExpanded
        self.habits = habits
        self.isCapture = isCapture
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var isRing: Bool {
        appSetting.calendarMode == .ring && habits.count <= 3
    }
    
    var week: Int {
        selectedDate.weekNum(startFromMon: appSetting.isMondayStart)
    }
    
    var dayOfWeekIndicator: some View {
        HStack(spacing: 4) {
            ForEach(
                appSetting.isMondayStart ? [2, 3, 4, 5, 6, 7, 1] : [1, 2, 3, 4, 5, 6, 7],
                id: \.self
            ) { dayOfWeek in
                Text(Date.dayOfTheWeekShortEngStr(dayOfWeek))
                    .subColor()
                    .bodyText()
                    .frame(width: 44)
            }
        }
    }
    
    var body: some View {
        CalendarInterface(
            selectedDate: $selectedDate,
            color: habits[0].color,
            isExpanded: $isExpanded,
            isEmojiView: $isEmojiView, habits: habits, isCapture: isCapture
        ) {
            if !isRing && habits.count > 1 {
                TableCalendar(
                    isExpanded: isExpanded, habits: habits,
                    selectedDate: selectedDate, isEmojiView: isEmojiView
                )
            } else {
                dayOfWeekIndicator
                if isEmojiView {
                    weekExpandWrapper { week in
                        EmojiCalendarRow(
                            week: week, isExpanded: isExpanded,
                            selectedDate: $selectedDate, habit: habits[0]
                        )
                    }
                } else {
                    if isRing {
                        expandWrapper { date in
                            Ring(habits: habits, date: date, selectedDate: selectedDate, isExpanded: isExpanded)
                        }
                    } else {
                        expandWrapper { date in
                            Tile(date: date, selectedDate: selectedDate, isExpanded: isExpanded, habits: habits)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func weekExpandWrapper<Content: View>(content: @escaping (Int) -> Content) -> some View {
        if isExpanded {
            VStack(spacing: 8) {
                ForEach(1...selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart),
                        id: \.self
                ) { week in
                    content(week)
                }
            }
        } else {
            content(week)
        }
    }
    
    @ViewBuilder
    func expandWrapper<Content: View>(content: @escaping (Date) -> Content) -> some View {
        if isExpanded {
            VStack(spacing: 8) {
                ForEach(1...selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart),
                        id: \.self
                ) { week in
                    HStack(spacing: 4) {
                        ForEach(
                            selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                            id: \.self
                        ) { date in
                            Button(action: {selectedDate = date}) {
                                content(date)
                            }
                            .frame(width: 44)
                        }
                    }
                }
            }
        } else {
            HStack(spacing: 4) {
                ForEach(
                    selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                    id: \.self
                ) { date in
                    Button(action: {selectedDate = date}) {
                        content(date)
                    }
                    .frame(width: 44)
                }
            }
        }
    }
}

struct HabitCalendar_Previews: PreviewProvider {
    static var previews: some View {
        HabitCalendar(selectedDate: .constant(Date()), isEmojiView: .constant(false),
                      isExpanded: .constant(false), habits: .init(contents: [FlHabit.habit1, FlHabit.habit2])
        )
        .environmentObject(AppSetting())
    }
}
