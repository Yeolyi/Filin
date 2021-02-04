//
//  EmojiCalendarRow.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct EmojiCalendarRow: View {
    let week: Int
    let isExpanded: Bool
    
    @Binding var selectedDate: Date
    
    @ObservedObject var habit: FlHabit
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(
                selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1), id: \.self
            ) { date in
                Button(action: { self.selectedDate = date }) {
                    VStack(spacing: 3) {
                        Text(String(date.day))
                            .foregroundColor(
                                selectedDate.dictKey == date.dictKey ? habit.color :
                                    (
                                        (date.month != selectedDate.month && isExpanded) ?
                                            ThemeColor.inActive(colorScheme) :
                                            ThemeColor.mainColor(colorScheme)
                                    )
                            )
                            .bodyText()
                        Group {
                            if habit.dailyEmoji[date.dictKey] != nil {
                                Text(habit.dailyEmoji[date.dictKey]!)
                                    .headline()
                            } else {
                                Circle()
                                    .inactiveColor()
                            }
                        }
                        .frame(width: 24, height: 30)
                        .opacity((date.month != selectedDate.month && isExpanded) ? 0.3 : 1)
                    }
                }
                .frame(width: 40)
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
}
/*
 struct EmojiCalendarRow_Previews: PreviewProvider {
 static var previews: some View {
 EmojiCalendarRow()
 }
 }
 */
