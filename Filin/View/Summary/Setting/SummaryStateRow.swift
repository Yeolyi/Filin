//
//  SummaryStateRow.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct SummaryStateRow: View {
    
    let num: Int
    var habit: FlHabit? {
        habitManager.contents.first(where: {
            $0.id == targetHabit
        })
    }
    
    @Binding var targetHabit: UUID?
    
    @EnvironmentObject var habitManager: HabitManager
    
    var description: String {
        switch num {
        case 1:
            return "Habit 1(Outermost ring)".localized
        case 2:
            return "Habit 2".localized
        case 3:
            return "Habit 3(Innermost ring)".localized
        default:
            assertionFailure()
            return "First ring".localized
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(description)
                    .bodyText()
                    .mainColor()
                Spacer()
                Text(habit?.name ?? "Empty".localized)
                    .subColor()
                    .bodyText()
            }
            NavigationLink(destination:
                            HabitSelector(position: num, targetHabit: $targetHabit)
            ) {
                Rectangle()
                    .opacity(0)
            }
        }
        .flatRowBackground()
    }
}

/*
struct SummaryStateRow_Previews: PreviewProvider {
    static var previews: some View {
        SummaryStateRow(num: 1)
    }
}
*/
