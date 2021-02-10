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
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        if habit.isTimerUsed {
            NavigationLink(
                destination:
                    HabitTimer(date: date, habit: habit, offlineTime: appSetting.sceneBackgroundTime)
            ) {
                Image(systemName: showCheck ? "clock.fill" : "clock")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(height: 44)
            }
        } else {
            Button(action: {
                withAnimation {
                    habit.achievement.set(at: appSetting.mainDate, using: { current, addUnit in
                        current + addUnit
                    })
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }) {
                Image(systemName: showCheck ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(habit.color)
                    .frame(height: 44)
            }
        }
    }
}

struct HabitCheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckButton(date: Date())
            .environmentObject(FlHabit(name: "Test"))
            .previewDevice(.init(stringLiteral: "iPhone 12 Pro"))
    }
}
