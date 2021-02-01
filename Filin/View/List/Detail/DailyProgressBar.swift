//
//  DailyProgressBar.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/01.
//

import SwiftUI

struct DailyProgressBar: View {
    
    let selectedDate: Date
    @State var isSetMode = true
    
    @EnvironmentObject var habit: FlHabit
    
    var setAvailable: Bool {
        return habit.achievement.addUnit != 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("""
                    \(habit.achievement.content[selectedDate.dictKey] ?? 0)\(" times".localized)/\
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
        }
        .rowBackground()
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
                habit.objectWillChange.send()
            }
            if habit.achievement.content[selectedDate.dictKey] == 0 {
                habit.achievement.content[selectedDate.dictKey] = nil
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
}
