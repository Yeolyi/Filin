//
//  SummaryLegend.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI

struct SummaryLegend: View {
    
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var habitManager: HabitManager
    
    var habits: [FlHabit] {
        let temp = summaryManager.contents[0].list.compactMap { id in
            habitManager.contents.first(where: {
                $0.id == id
            })
        }
        return temp
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(habits) { habit in
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(habit.color)
                    Text(habit.name)
                        .font(.custom("GodoB", size: 16))
                }
            }
        }
        .flatRowBackground()
    }
}

struct SummaryLegend_Previews: PreviewProvider {
    static var previews: some View {
        SummaryLegend()
    }
}
