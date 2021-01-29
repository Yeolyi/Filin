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
    
    @ObservedObject var habit1: FlHabit
    @ObservedObject var habit2: FlHabit
    @ObservedObject var habit3: FlHabit
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var habitsWrapped: [FlHabit?] {
        [
            habit1.requiredSec == -1 ? nil : habit1,
            habit2.requiredSec == -1 ? nil : habit2,
            habit3.requiredSec == -1 ? nil : habit3
        ]
    }
    
    init(selectedDate: Binding<Date>, isExpanded: Bool = false,
         isEmojiView: Bool = false,
         habit1: FlHabit? = nil, habit2: FlHabit? = nil, habit3: FlHabit? = nil) {
        if habit1 == nil && habit2 == nil && habit3 == nil {
            assertionFailure()
        }
        self._selectedDate = selectedDate
        self._isExpanded = State(initialValue: isExpanded)
        self._isEmojiView = State(initialValue: isEmojiView)
        let nilHabit = FlHabit(name: "Nil")
        nilHabit.requiredSec = -1
        self.habit1 = habit1 == nil ? nilHabit : habit1!
        self.habit2 = habit2 == nil ? nilHabit : habit2!
        self.habit3 = habit3 == nil ? nilHabit : habit3!
    }
    
    var body: some View {
        CalendarInterface(
            selectedDate: $selectedDate,
            color: habitsWrapped.compactMap({$0})[0].color,
            isExpanded: $isExpanded,
            isEmojiView: $isEmojiView
        ) { week, isExpanded in
            if isEmojiView {
                EmojiCalendarRow(
                    week: week, isExpanded: isExpanded, selectedDate: $selectedDate,
                    habit: habitsWrapped.compactMap({$0})[0]
                )
            } else {
               WeekendRow(
                selectedDate: $selectedDate, habit1: habit1, habit2: habit2, habit3: habit3,
                week: week, isExpanded: isExpanded
               )
            }
        }
    }
}

struct WeekendRow: View {
    
    @Binding var selectedDate: Date
    
    @ObservedObject var habit1: FlHabit
    @ObservedObject var habit2: FlHabit
    @ObservedObject var habit3: FlHabit
    
    var habitsWrapped: [FlHabit?] {
        [
            habit1.requiredSec == -1 ? nil : habit1,
            habit2.requiredSec == -1 ? nil : habit2,
            habit3.requiredSec == -1 ? nil : habit3
        ]
    }
    
    let week: Int
    let isExpanded: Bool
    
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(
                selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                id: \.self
            ) { date in
                CircleProgress(CalendarRingDesign.getRingTuple(
                    at: date, habits: habitsWrapped, selectedDate: selectedDate, colorScheme: colorScheme
                )) {
                    Text(appSetting.mainDate.dictKey == date.dictKey ? "✓" : String(date.day))
                        .foregroundColor(
                            CalendarRingDesign.textColor(
                                at: date, habits: habitsWrapped, selectedDate: selectedDate,
                                isExpanded: isExpanded, colorScheme: colorScheme)
                        )
                        .bodyText()
                }
                .onTapGesture { selectedDate = date }
            }
        }
        .padding(.bottom, 10)
    }
}

/*
 struct CustomCalendar_Previews: PreviewProvider {
 static var previews: some View {
 CalendarRow(selectedDate: .constant(Date()), habit: , isExpanded: true)
 }
 }
 */
