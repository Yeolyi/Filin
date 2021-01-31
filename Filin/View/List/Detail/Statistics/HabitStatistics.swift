//
//  HabitStatistics.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/03.
//

import SwiftUI

struct HabitStatistics: View {
    
    @EnvironmentObject var habit: FlHabit
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                HStack {
                    Text("Trend(week)".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: habit.weeklyTrend(mainDate: appSetting.mainDate))
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Trend(month)".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: habit.monthlyTrend(mainDate: appSetting.mainDate))
            }
            DayOfWeekChart(habit: habit, mainDate: appSetting.mainDate)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Continuous Achievement".localized)
                        .bodyText()
                    Spacer()
                }
                Text("\(habit.continousAchievementCount(appSetting.mainDate))\(" days".localized)")
                    .foregroundColor(habit.color)
                    .headline()
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Continuous Blank".localized)
                        .bodyText()
                    Spacer()
                }
                Text("\(habit.continousInachievementCount(appSetting.mainDate))\(" days".localized)")
                    .foregroundColor(habit.color)
                    .headline()
            }
            if habit.firstDay != nil {
                VStack(spacing: 0) {
                    HStack {
                        Text("Since".localized)
                            .bodyText()
                        Spacer()
                    }
                    HStack {
                        Text(habit.firstDay!.localizedYearMonthDay)
                            .foregroundColor(habit.color)
                            .headline()
                        Spacer()
                    }
                }
            }
            Text("""
                Trends are based on how your metrics have moved over the \
                last specific days as compared to the last 100 days.
                """)
                .subColor()
                .bodyText()
                .padding(.top, 8)
        }
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
                Text("Needs more data".localized)
                    .subColor()
                    .headline()
                Spacer()
            }
        } else {
            HStack {
                Image(systemName: imageName(value: value!))
                    .foregroundColor(habit.color)
                    .headline()
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
            .environmentObject(FlHabit.habit1)
    }
}
