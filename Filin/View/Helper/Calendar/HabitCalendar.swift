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
    @Binding var isCalendarExpanded: Bool
    
    @ObservedObject var habits: HabitGroup
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        CalendarInterface(
            selectedDate: $selectedDate,
            color: habits.count == 1 ? habits.contents[0].color : ThemeColor.subColor(colorScheme),
            isExpanded: $isCalendarExpanded,
            isEmojiView: $isEmojiView
        ) { week, isExpanded in
            if isEmojiView {
                EmojiCalendarRow(
                    week: week, isExpanded: isCalendarExpanded, selectedDate: $selectedDate,
                    habit: habits.contents[0]
                )
            } else {
                HStack(spacing: 4) {
                    ForEach(
                        selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                        id: \.self
                    ) { date in
                        Button(action: {selectedDate = date}) {
                            if appSetting.calendarMode == .tile {
                                Tile(date: date, selectedDate: selectedDate, isExpanded: isExpanded, habits: habits)
                            } else {
                                Ring(habits: habits, date: date, selectedDate: selectedDate, isExpanded: isExpanded)
                            }
                        }
                        .frame(width: 44)
                    }
                }
            }
        }
    }
}
