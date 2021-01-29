//
//  DayOfWeekChart.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/03.
//

import SwiftUI

struct DayOfWeekChart: View {
    @Environment(\.colorScheme) var colorScheme
    let dayOfWeekTrend: [Double]
    let trendToGraphHeight: [CGFloat]
    let color: Color
    let dayOfWeek: Set<Int>
    
    init(habit: FlHabit) {
        func roundAndCut(_ num: Double) -> Double {
            round(num*10)/10
        }
        self.dayOfWeek = habit.dayOfWeek
        var weeklyData = [Int](repeating: 0, count: 7)
        for diff in -7 ... -1 {
            let datePointer = Date().addDate(diff)!
            weeklyData[datePointer.dayOfTheWeek - 1] = Int(habit.achievement.content[datePointer.dictKey] ?? 0)
        }
        let dayOfWeekAverage = habit.dayOfWeekAverage
        let trendOriginal = weeklyData.enumerated().map { Double($1) - dayOfWeekAverage[$0] }
        dayOfWeekTrend = trendOriginal.map(roundAndCut)
        self.color = habit.color
        
        trendToGraphHeight = dayOfWeekTrend.map {
            let realValue = CGFloat($0 * 120 / Double(habit.achievement.numberOfTimes))
            return min(59, max(-59, realValue))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trend(day of the week)")
                    .bodyText()
                Spacer()
            }
            Spacer()
            ZStack {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0..<7) { index in
                        if dayOfWeek.contains(index+1) {
                            VStack(spacing: 0) {
                                Spacer()
                                Text(String(dayOfWeekTrend[index]))
                                    .foregroundColor(
                                        Date().dayOfTheWeek == index + 1 ? color : ThemeColor.subColor(colorScheme)
                                    )
                                    .bodyText()
                                Rectangle()
                                    .foregroundColor(
                                        Date().dayOfTheWeek == index + 1 ? color : ThemeColor.subColor(colorScheme)
                                    )
                                    .frame(width: 24, height: abs(trendToGraphHeight[index]))
                                    .padding(.bottom, 3)
                                Text(Date.dayOfTheWeekShortStr(index + 1))
                                    .foregroundColor(
                                        Date().dayOfTheWeek == index + 1 ? color : ThemeColor.subColor(colorScheme)
                                    )
                                    .bodyText()
                            }
                            .animation(.default)
                            .frame(width: 40)
                            .offset(y: trendToGraphHeight[index] > 0 ? -60 : -60 - trendToGraphHeight[index])
                        } else {
                            VStack(spacing: 0) {
                                Spacer()
                                Text("0.0")
                                    .subColor()
                                    .bodyText()
                                Rectangle()
                                    .subColor()
                                    .frame(width: 24, height: 60)
                                    .padding(.bottom, 3)
                                    .hidden()
                                Text(Date.dayOfTheWeekShortStr(index + 1))
                                    .subColor()
                                    .bodyText()
                                    .frame(width: 24)
                            }
                            .opacity(0.5)
                            .frame(width: 40)
                            .hidden()
                        }
                    }
                }
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .subColor()
                        .frame(width: 330, height: 2)
                    Rectangle()
                        .foregroundColor(color)
                        .frame(width: 35, height: 60)
                        .padding(.bottom, 3)
                        .hidden()
                    Text("F")
                        .bodyText()
                        .frame(width: 24)
                        .hidden()
                }
            }
            .frame(height: 160)
        }
        .frame(height: 180)
    }
}
