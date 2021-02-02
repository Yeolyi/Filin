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
    
    @State var isTapping = false
    @State var activeSheet: DetailViewActiveSheet?
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    init(habit: FlHabit, showAdd: Bool, date: Date? = nil) {
        self.habit = habit
        self.showAdd = showAdd
        self.date = date
    }
    
    var subTitle: String {
        var subTitleStr = ""
        if !habit.isDaily {
            for dayOfWeek in habit.dayOfWeek.sorted() {
                subTitleStr += "\(Date.dayOfTheWeekStr(dayOfWeek)), "
            }
            _ = subTitleStr.popLast()
            _ = subTitleStr.popLast()
        } else {
            subTitleStr = "Every day".localized
        }
        return subTitleStr
    }
    
    var body: some View {
        HStack(spacing: 0) {
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
                            Text(subTitle)
                                .subColor()
                                .bodyText()
                            Spacer()
                        }
                        HStack {
                            Text(habit.name)
                                .foregroundColor(habit.color)
                                .headline()
                            Spacer()
                        }
                    }
                    if habit.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek) {
                        VStack(spacing: 3) {
                            ZStack {
                                Text("\(habit.achievement.content[date?.dictKey ?? appSetting.mainDate.dictKey] ?? 0)")
                                    .foregroundColor(habit.color)
                                    .bodyText()
                                    .offset(
                                        x: min(75.0, -75.0 + 150.0 / CGFloat(habit.achievement.numberOfTimes) *
                                            CGFloat(
                                                habit.achievement.content[date?.dictKey ?? appSetting.mainDate.dictKey]
                                                    ?? 0)
                                            ),
                                        y: -23
                                    )
                            LinearProgressBar(
                                color: habit.color,
                                progress: habit.achievement.progress(at: date ?? appSetting.mainDate) ?? 0
                            )
                            }
                        }
                        .frame(width: 150)
                        .offset(y: 5)
                        .padding(.trailing, 10)
                    }
                }
            }
            .padding(.leading, 5)
        }
        .rowBackground()
    }
}

struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = DataSample.shared
        HabitRow(habit: FlHabit(name: "Test"), showAdd: true)
            .environmentObject(coredataPreview.habitManager)
            .environmentObject(AppSetting())
    }
}
