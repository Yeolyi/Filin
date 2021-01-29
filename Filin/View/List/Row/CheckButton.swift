//
//  HabitCheckButton.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI
import AVFoundation

struct CheckButton: View {

    var showCheck: Bool {
        habit.achievement.isDone(at: date)
    }
    let date: Date
    @EnvironmentObject var habit: FlHabit
    
    var body: some View {
        if habit.isTimer {
            NavigationLink(
                destination:
                    HabitTimer(date: date).environmentObject(habit)
            ) {
                Image(systemName: showCheck ? "clock.fill" : "clock")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(width: 44, height: 44)
            }
        } else {
            Button(action: {
                withAnimation {
                    habit.achievement.set(at: Date(), using: { current, addUnit in
                        current + addUnit
                    })
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }) {
                Image(systemName: showCheck ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

struct HabitCheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckButton(date: Date())
            .environmentObject(FlHabit(name: "Test"))
    }
}
