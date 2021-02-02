//
//  CaptureCalendar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/20.
//

import SwiftUI

struct CaptureCalendar: View {
    
    let isEmojiView: Bool
    let selectedDate: Date
    let isExpanded: Bool
    @ObservedObject var habits: HabitGroup
    
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
    var color: Color {
        habits[0].color
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 3) {
                        Text(habits[0].name)
                            .foregroundColor(color)
                            .headline()
                        Spacer()
                        Text(selectedDate.localizedYearMonth)
                            .foregroundColor(color)
                            .bodyText()
                    }
                }
                Spacer()
            }
            .padding(.bottom, 15)
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(
                        1..<selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart) + 1, id: \.self
                    ) { week in
                        calendarContent(week: week)
                    }
                }
            } else {
                calendarContent(week: selectedDate.weekNum(startFromMon: appSetting.isMondayStart))
            }
        }
    }
    
    @ViewBuilder
    func calendarContent(week: Int) -> some View {
        if isEmojiView {
            EmojiCalendarRow(
                week: week, isExpanded: isExpanded,
                selectedDate: .constant(selectedDate), habit: habits[0]
            )
        } else {
            HStack(spacing: 4) {
                ForEach(
                    selectedDate.daysInSameWeek(week: week, from: appSetting.isMondayStart ? 2 : 1),
                    id: \.self
                ) { date in
                    Group {
                        if appSetting.calendarMode == .ring {
                            Ring(habits: habits, date: date, selectedDate: selectedDate, isExpanded: isExpanded)
                        } else {
                            Tile(date: date, selectedDate: selectedDate, isExpanded: isExpanded, habits: habits)
                        }
                    }
                    .frame(width: 44)
                }
            }
        }
    }
}

struct CaptureCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CaptureCalendar(
            isEmojiView: false, selectedDate: Date(), isExpanded: true, habits: .init(contents: [FlHabit.habit1])
        )
        .environmentObject(AppSetting())
        .rowBackground()
    }
}
