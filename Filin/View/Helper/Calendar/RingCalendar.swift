//
//  RingsCalendar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/10.
//

import SwiftUI

struct RingCalendar: View {
    
    @Binding var selectedDate: Date
    
    @State var isExpanded = false
    @State var isEmojiView = false
    
    @ObservedObject var habits: HabitGroup
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var habitManager: HabitManager
    
    var body: some View {
        CalendarInterface(
            selectedDate: $selectedDate,
            color: habits.contents[0].color,
            isExpanded: $isExpanded,
            isEmojiView: $isEmojiView
        ) { week, isExpanded in
            if isEmojiView {
                EmojiCalendarRow(
                    week: week, isExpanded: isExpanded, selectedDate: $selectedDate,
                    habit: habits.contents[0]
                )
            } else {
                HStack(spacing: 4) {
                    ForEach(
                        selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                        id: \.self
                    ) { date in
                        Button(action: {selectedDate = date}) {
                            Ring(habits: habits, date: date, selectedDate: selectedDate, isExpanded: isExpanded)
                            /*
                            if appSetting.useRing {
                                Ring(habits: habits, date: date)
                            } else {
                                Tile(date: date, selectedDate: selectedDate, isExpanded: isExpanded, habits: habits)
                            }
 */
                        }
                        .frame(width: 44)
                    }
                }
            }
        }
    }
}
