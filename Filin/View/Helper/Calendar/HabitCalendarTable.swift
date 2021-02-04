//
//  HabitCalendarTable.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct HabitCalendarTable: View {
    
    @Binding var isExpanded: Bool
    @Binding var isEmojiView: Bool
    @Binding var selectedDate: Date
    let imageAspect: ImageSize?
    
    init(isExpanded: Binding<Bool>, isEmojiView: Binding<Bool>,
         selectedDate: Binding<Date>, habits: HabitGroup, imageSize: ImageSize? = nil) {
        guard !habits.isEmpty else {
            assertionFailure()
            _isExpanded = .constant(false)
            _isEmojiView = .constant(false)
            _selectedDate = .constant(Date())
            self.habits  = habits
            imageAspect = nil
            return
        }
        self._isExpanded = isExpanded
        self._isEmojiView = isEmojiView
        self._selectedDate = selectedDate
        self.imageAspect = imageSize
        self.habits = habits
    }
    
    @ObservedObject var habits: HabitGroup
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 5) {
                if imageAspect == nil {
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
                                .foregroundColor(habits[0].color)
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
                                            .foregroundColor(habits[0].color)
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Image(systemName: "face.smiling")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(habits[0].color)
                                            .mainColor()
                                    }
                                }
                                .frame(width: 44, height: 44)
                            }
                        }
                    }
                }
                VStack(spacing: 15) {
                    if isExpanded {
                        ForEach(1...selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart), id: \.self
                        ) { week in
                            WeekTable(habits: habits, week: week, selectedDate: selectedDate, isEmojiView: isEmojiView)
                            if week != selectedDate.weekNuminMonth(isMondayStart: appSetting.isMondayStart) {
                                Divider()
                            }
                        }
                    } else {
                        WeekTable(
                            habits: habits,
                            week: selectedDate.weekNum(startFromMon: appSetting.isMondayStart),
                            selectedDate: selectedDate, isEmojiView: isEmojiView
                        )
                    }
                    
                }
                if imageAspect == nil {
                    BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                        withAnimation { self.isExpanded.toggle() }
                    }
                    .padding(.bottom, 10)
                }
            }
            .rowBackground(innerBottomPadding: imageAspect == nil ? false : true)
            if imageAspect != nil {
                HStack(spacing: 4) {
                    Spacer()
                    Image(colorScheme == .light ? "Icon1024" : "icon_dark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .cornerRadius(4)
                    Text("FILIN")
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.trailing, 10)
            }
        }
        .if(imageAspect != nil && imageAspect! != .free) {
            $0.frame(width: imageAspect!.sizeTuple.width, height: imageAspect!.sizeTuple.height)
        }
        .if(imageAspect != nil && imageAspect! == .free) {
            $0.frame(width: 400)
        }
        .if(imageAspect != nil) {
            $0.padding(.horizontal, imageAspect!.paddingSize.horizontal)
                .padding(.vertical, imageAspect!.paddingSize.vertical)
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
                                    Group {
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

struct HabitCalendarTable_Previews: PreviewProvider {
    
    private struct StateWrapper: View {
        @State var selectedDate = Date()
        @State var isExpanded = false
        let dataSample = DataSample.shared
        var body: some View {
            ScrollView {
                HabitCalendarTable(
                    isExpanded: $isExpanded, isEmojiView: .constant(false),
                    selectedDate: $selectedDate, habits: .init(contents: dataSample.habitManager.contents)
                )
                .environmentObject(AppSetting())
            }
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
