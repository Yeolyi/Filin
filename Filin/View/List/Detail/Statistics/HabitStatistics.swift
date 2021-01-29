//
//  HabitStatistics.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/03.
//

import SwiftUI

struct HabitStatistics: View {
    
    @ObservedObject var habit: FlHabit
    
    var weeklyTrend: Double? {
        guard habit.firstDay.daysFromToday >= 6 else {
            return nil
        }
        return habit.weeklyAverage(at: Date()) - habit.yearAverage
    }
    
    var monthlyTrend: Double? {
        let lastMonth = Date().addMonth(-1)
        let requiredDays = lastMonth.daysFromToday - 1
        guard habit.firstDay.daysFromToday >= requiredDays else {
            return nil
        }
        return habit.monthlyAverage(at: Date()) - habit.yearAverage
    }
    
    func textWithChevron(value: Double?) -> AnyView {
        func roundAndCut(_ num: Double) -> String {
            String(format: "%.1f", abs(round(num*10)/10))
        }
        guard let value = value else {
            return AnyView(
                HStack {
                    Text("Needs more data".localized)
                        .subColor()
                        .headline()
                    Spacer()
                }
            )
        }
        var image: Image
        switch value {
        case .greatestFiniteMagnitude * -1 ..< 0:
            image = Image(systemName: "chevron.down")
        case 0:
            image = Image(systemName: "minus")
        default:
            image = Image(systemName: "chevron.up")
        }
        return AnyView(
            HStack {
                image
                    .foregroundColor(habit.color)
                    .headline()
                Text(roundAndCut(value) + " times".localized)
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 0) {
                HStack {
                    Text("Trend(week)".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: weeklyTrend)
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Trend(month)".localized)
                        .bodyText()
                    Spacer()
                }
                textWithChevron(value: monthlyTrend)
            }
            
            DayOfWeekChart(habit: habit)
            VStack(spacing: 0) {
                HStack {
                    Text("Since".localized)
                        .bodyText()
                    Spacer()
                }
                HStack {
                    Text(habit.firstDay.localizedYearMonthDay)
                        .foregroundColor(habit.color)
                        .headline()
                    Spacer()
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
}
