//
//  MainRow.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitRow: View {
    
    let showAdd: Bool
    var date: Date?
    
    @ObservedObject var habit: FlHabit
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    init(habit: FlHabit, showAdd: Bool, date: Date? = nil) {
        self.habit = habit
        self.showAdd = showAdd
        self.date = date
    }
    
    var dayOfWeekDescription: String {
        if habit.dayOfWeek.count == 7 {
            return "Every day".localized
        } else {
            return habit.dayOfWeek.sorted().map {
                Date.dayOfTheWeekShortStr($0)
            }.joined(separator: ", ")
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            if showAdd {
                CheckButton(date: date ?? appSetting.mainDate)
                    .environmentObject(habit)
            }
            NavigationLink(destination:
                            HabitDetailView(habit: habit)
                            .environmentObject(habit)
            ) {
                HStack {
                    VStack {
                        HStack {
                            Text(dayOfWeekDescription)
                                .subColor()
                                .bodyText()
                            Spacer()
                        }
                        HStack {
                            Text(habit.name)
                                .foregroundColor(habit.color)
                                .font(.custom("GodoB", size: 20))
                            Spacer()
                        }
                    }
                    if habit.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek) {
                        VStack(spacing: 3) {
                            ZStack {
                                Text("\(habit.achievement.numberDone(at: date ?? appSetting.mainDate))")
                                    .foregroundColor(habit.color)
                                    .bodyText()
                                    .offset(
                                        x: min(75.0, -75.0 + 150.0 / CGFloat(habit.achievement.targetTimes) *
                                            CGFloat(habit.achievement.numberDone(at: date ?? appSetting.mainDate))),
                                        y: -23
                                    )
                            LinearProgressBar(
                                color: habit.color,
                                progress: habit.achievement.progress(at: date ?? appSetting.mainDate) 
                            )
                            }
                        }
                        .frame(width: 150)
                        .offset(y: 5)
                        .padding(.trailing, 5)
                    }
                }
            }
        }
        .rowBackground()
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = PreviewDataProvider.shared
        HabitRow(habit: FlHabit(name: "10분 걷기"), showAdd: true)
            .environmentObject(coredataPreview.habitManager)
            .environmentObject(AppSetting())
    }
}
