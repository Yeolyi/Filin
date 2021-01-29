//
//  TodayHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TodayInformation: View {
    
    @EnvironmentObject var habit: FlHabit
    @Binding var selectedDate: Date
    @State var tappingMinus = false
    @State var tappingPlus = false
    @State var isSetMode = true
    @State var isExpanded = false
    
    var setAvailable: Bool {
        return habit.achievement.addUnit != 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("""
                    \(habit.achievement.content[selectedDate.dictKey] ?? 0)\(" times".localized)/ \
                    \(habit.achievement.numberOfTimes)\(" times".localized)
                    """)
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
                if setAvailable {
                    BasicTextButton(isSetMode ? "±\(habit.achievement.addUnit)" : "±1") { isSetMode.toggle() }
                }
            }
            HStack {
                LinearProgressBar(
                    color: habit.color,
                    progress: Double(habit.achievement.content[selectedDate.dictKey] ?? 0)
                        / Double(habit.achievement.numberOfTimes)
                )
                moveButton(isAdd: false)
                moveButton(isAdd: true)
            }
            if isExpanded {
                HabitStatistics(habit: habit)
                    .padding(.top, 15)
            }
            BasicButton(isExpanded ? "chevron.compact.up" : "chevron.compact.down") {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }
        }
        .rowBackground(innerBottomPadding: false)
    }
    func moveButton(isAdd: Bool) -> some View {
        BasicButton(isAdd ? "plus" : "minus") {
            withAnimation {
                habit.achievement.set(at: selectedDate, using: { val, addUnit in
                    if isAdd {
                        return val + (isSetMode ? addUnit : 1)
                    } else {
                        return max(0, val - (isSetMode ? addUnit : 1))
                    }
                })
            }
            if habit.achievement.content[selectedDate.dictKey] == 0 {
                habit.achievement.content[selectedDate.dictKey] = nil
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
}
