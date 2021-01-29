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
                    VStack {
                        Text(String(date.day))
                            .foregroundColor(
                                selectedDate.dictKey == date.dictKey ? habit.color : ThemeColor.mainColor(colorScheme)
                            )
                            .bodyText()
                        Text(habit.dailyEmoji[date.dictKey] ?? "")
                            .headline()
                            .frame(width: 40, height: 40)
                    }
                }
                .opacity(selectedDate.month == date.month ? 1 : 0.5)
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
