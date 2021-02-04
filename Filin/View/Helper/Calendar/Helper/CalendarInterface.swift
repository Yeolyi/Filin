//
//  CalendarRow.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

/// - Note: AppSetting이 전달되어야함. 근데 왜 body 변수는 연산 프로퍼티일까?
struct CalendarInterface<Content: View>: View {
    
    @State var isAnimation = false
    
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    @Binding var isEmojiView: Bool
    
    let content: (_ week: Int, _ isExpanded: Bool) -> Content
    let color: Color
    
    @ObservedObject var habits: HabitGroup
    
    @EnvironmentObject var appSetting: AppSetting
    
    init(selectedDate: Binding<Date>, color: Color, isExpanded: Binding<Bool>, isEmojiView: Binding<Bool>,
         habits: HabitGroup,
         @ViewBuilder content: @escaping (_ week: Int, _ isExpanded: Bool) -> Content
    ) {
        self._selectedDate = selectedDate
        self._isExpanded = isExpanded
        self._isEmojiView = isEmojiView
        self.content = content
        self.color = color
        self.habits = habits
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                HStack(spacing: 10) {
                    Button(action: {
                        if isExpanded { selectedDate = selectedDate.addMonth(-1)
                        } else { selectedDate = selectedDate.addDate(-7)! }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .subColor()
                    }
                    Text(isExpanded ? selectedDate.localizedYearMonth : selectedDate.localizedMonthDay)
                        .foregroundColor(color)
                        .font(.system(size: 20, weight: .semibold))
                    Button(action: {
                        if isExpanded { selectedDate = selectedDate.addMonth(1)
                        } else { selectedDate = selectedDate.addDate(7)! }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                            .subColor()
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation { isEmojiView.toggle() }
                    }) {
                        Group {
                            if !isEmojiView {
                                Circle()
                                    .trim(from: 0.0, to: 0.7)
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round))
                                    .foregroundColor(color)
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(color)
                                    .mainColor()
                            }
                        }
                        .frame(width: 44, height: 44)
                    }
                }
            }
            VStack(spacing: 8) {
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
                if isExpanded {
                    ForEach(
                        1..<selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart) + 1,
                        id: \.self
                    ) { week in
                        content(week, true)
                    }
                } else {
                    content(selectedDate.weekNum(startFromMon: appSetting.isMondayStart), false)
                }
                ZStack {
                    VStack {
                        Spacer()
                        BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                            withAnimation {
                                self.isExpanded.toggle()
                            }
                        }
                    }
                    if habits.contents.count > 1 {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(habits.contents) { habit in
                                    HStack(spacing: 5) {
                                        Circle()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(habit.color)
                                        Text(habit.name)
                                            .foregroundColor(habit.color)
                                            .font(.system(size: 12, weight: .bold))
                                    }
                                }
                            }
                            .padding(.vertical)
                            Spacer()
                        }
                    }
                }
            }
        }
        .rowBackground(innerBottomPadding: false)
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    struct StateWrapper: View {
        @State var selectedDate = Date()
        @State var isExpanded = false
        @State var isEmojiView = false
        var body: some View {
            HabitCalendar(
                selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                isCalendarExpanded: $isExpanded,
                habits: .init(contents: [FlHabit.habit1, FlHabit.habit2])
            )
            .environmentObject(AppSetting())
        }
    }
    static var previews: some View {
        StateWrapper()
    }
}
