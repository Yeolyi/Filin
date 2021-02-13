//
//  HabitStatistics.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/03.
//

import SwiftUI

struct HabitStatistics: View {
    
    @State var isExpanded = false
    
    @EnvironmentObject var habit: FlHabit
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                HStack {
                    Text("Weekly Trends".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: habit.achievement.weeklyTrend(mainDate: appSetting.mainDate))
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Monthly Trends".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: habit.achievement.monthlyTrend(mainDate: appSetting.mainDate))
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Continuous Achievement".localized)
                        .bodyText()
                    Spacer()
                }
                Text("\(habit.achievement.continousAchievementCount(appSetting.mainDate))\(" days".localized)")
                    .foregroundColor(habit.color)
                    .headline()
            }
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Continuous Blank".localized)
                            .bodyText()
                        Spacer()
                    }
                    Text("\(habit.achievement.continousInachievementCount(appSetting.mainDate))\(" days".localized)")
                        .foregroundColor(habit.color)
                        .headline()
                }
                DayOfWeekChart(habit: habit, mainDate: appSetting.mainDate)
                if habit.achievement.firstDay != nil {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Since".localized)
                                .bodyText()
                            Spacer()
                        }
                        HStack {
                            Text(habit.achievement.firstDay!.localizedYearMonthDay)
                                .foregroundColor(habit.color)
                                .headline()
                            Spacer()
                        }
                    }
                }
            }
            Text("Trend compares the achievements of a particular period to the average of the last 100 days.".localized)
                .subColor()
                .bodyText()
                .padding(.top, 8)
            IconButton(imageName: isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }
        }
        .rowBackground(innerBottomPadding: false)
    }
    
    func imageName(value: Double) -> String {
        switch value {
        case _ where value < 0:
            return "chevron.down"
        case _ where value > 0:
            return "chevron.up"
        default:
            return "minus"
        }
    }
    
    @ViewBuilder
    func textWithChevron(value: Double?) -> some View {
        if value == nil {
            HStack {
                Text("Needs More Data".localized)
                    .subColor()
                    .headline()
                Spacer()
            }
        } else {
            HStack {
                Image(systemName: imageName(value: value!))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                Text(String(format: "%.1f", abs(round(value!*10)/10)) + " times".localized)
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
            }
        }
    }
}

struct HabitStatistics_Previews: PreviewProvider {
    static var previews: some View {
        HabitStatistics()
            .environmentObject(FlHabit.sample(number: 0))
    }
}
