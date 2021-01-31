//
//  DayOfWeekChart.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/03.
//

import SwiftUI

struct DayOfWeekChart: View {
    
    @ObservedObject var habit: FlHabit
    var trendToGraphHeight: [CGFloat] = []
    var dayOfWeekTrend: [Double] = []
    
    init(habit: FlHabit, mainDate: Date) {
        self.habit = habit
        self.dayOfWeekTrend = habit.dayOfWeekTrend(settingDate: mainDate)
        trendToGraphHeight = dayOfWeekTrend.map {
            let realValue = CGFloat($0 * 120 / Double(habit.achievement.numberOfTimes))
            return min(60, max(-60, realValue))
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Trend(day of the week)")
                    .bodyText()
                Spacer()
            }
            .padding(.bottom, 25)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { index in
                    ZStack {
                        VStack(spacing: 0) {
                            Rectangle()
                                .subColor()
                                .opacity(0.1)
                                .frame(width: 24, height: 120)
                                .zIndex(0)
                        }
                            VStack(spacing: 0) {
                                Spacer()
                                Text(String(round(dayOfWeekTrend[index]*10)/10))
                                    .subColor()
                                    .bodyText()
                                Rectangle()
                                    .foregroundColor(habit.color)
                                    .frame(
                                        width: 24,
                                        height: abs(trendToGraphHeight[index]) == 0 ? 3 : abs(trendToGraphHeight[index])
                                    )
                            }
                            .animation(.default)
                            .frame(width: 40)
                            .offset(y: trendToGraphHeight[index] == 0 ? -57 :
                                        (trendToGraphHeight[index] > 0 ? -60 : -60 - trendToGraphHeight[index])
                            )
                            .zIndex(1)
                            .opacity(habit.dayOfWeek.contains(index + 1) ? 1 : 0)
                    }
                }
            }
            .frame(height: 120)
            HStack(spacing: 8) {
                ForEach(0..<7) { index in
                    Text(Date.dayOfTheWeekShortStr(index + 1))
                        .foregroundColor(
                            appSetting.mainDate.dayOfTheWeek == index + 1 ?
                                habit.color : ThemeColor.subColor(colorScheme)
                        )
                        .bodyText()
                        .frame(width: 40)
                }
            }
        }
    }
}

struct DayOfWeekChart_Previews: PreviewProvider {
    static var previews: some View {
        DayOfWeekChart(habit: DataSample.shared.habitManager.contents[0], mainDate: Date())
    }
}
