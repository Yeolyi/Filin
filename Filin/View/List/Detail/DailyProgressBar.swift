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
    @Binding var isEmojiMode: Bool
    
    @EnvironmentObject var habit: FlHabit
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("""
                    \(habit.achievement.numberDone(at: selectedDate))\(" times".localized)/\
                    \(habit.achievement.targetTimes)\(" times".localized)
                    """)
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
                if habit.achievement.isSet {
                    BasicTextButton(isSetMode ? "±\(habit.achievement.addUnit)" : "±1") { isSetMode.toggle() }
                }
            }
            HStack {
                LinearProgressBar(
                    color: habit.color,
                    progress: habit.achievement.progress(at: selectedDate)
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
                isEmojiMode = false
                habit.achievement.set(at: selectedDate, using: { val, addUnit in
                    if isAdd {
                        return val + (isSetMode ? addUnit : 1)
                    } else {
                        return max(0, val - (isSetMode ? addUnit : 1))
                    }
                })
                habit.objectWillChange.send()
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
}
