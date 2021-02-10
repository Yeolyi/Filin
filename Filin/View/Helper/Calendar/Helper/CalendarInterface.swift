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
    
    let content: Content
    let color: Color
    let isCapture: Bool
    var isRing: Bool {
        appSetting.calendarMode == .ring && habits.count <= 3
    }
    
    @ObservedObject var habits: HabitGroup
    
    @EnvironmentObject var appSetting: AppSetting
    
    init(selectedDate: Binding<Date>, color: Color, isExpanded: Binding<Bool>, isEmojiView: Binding<Bool>,
         habits: HabitGroup, isCapture: Bool = false,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedDate = selectedDate
        self._isExpanded = isExpanded
        self._isEmojiView = isEmojiView
        self.content = content()
        self.color = color
        self.habits = habits
        self.isCapture = isCapture
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                if isCapture {
                    if isRing || habits.count == 1 {
                        HStack(alignment: .bottom, spacing: 3) {
                            if habits.contents.count > 1  && isRing {
                                habitLegend
                            } else {
                                Text(habits[0]?.name ?? "")
                                    .foregroundColor(color)
                                    .headline()
                            }
                            Spacer()
                            Text(selectedDate.localizedYearMonth)
                                .foregroundColor(color)
                                .bodyText()
                        }
                        .padding(.bottom, 20)
                    }
                } else {
                    HStack {
                        dateIndicator
                        Spacer()
                        calendarModeButton
                    }
                }
            }
            VStack(spacing: 8) {
                content
                ZStack {
                    if !isCapture {
                        BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                            withAnimation { self.isExpanded.toggle() }
                        }
                    }
                    if habits.contents.count > 1 && isRing && !isCapture {
                        HStack {
                            habitLegend
                                .padding(.vertical)
                            Spacer()
                        }
                    }
                }
            }
        }
        .rowBackground(innerBottomPadding: isCapture ? true : false)
    }
    
    var habitLegend: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(habits.contents) { habit in
                HStack(spacing: 5) {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(habit.color)
                    Text(habit.name)
                        .foregroundColor(habit.color)
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
    }
    
    @ViewBuilder
    var dateIndicator: some View {
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
    }
    
    var calendarModeButton: some View {
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

struct CustomCalendar_Previews: PreviewProvider {
    struct StateWrapper: View {
        @State var selectedDate = Date()
        @State var isExpanded = false
        @State var isEmojiView = false
        var body: some View {
            HabitCalendar(
                selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                isExpanded: $isExpanded,
                habits: .init(contents: [FlHabit.sample(number: 1), FlHabit.sample(number: 2)])
            )
            .environmentObject(AppSetting())
        }
    }
    static var previews: some View {
        StateWrapper()
    }
}
