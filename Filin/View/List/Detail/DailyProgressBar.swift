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
        VStack(spacing: 3) {
            HStack {
                Text("""
                    \(habit.achievement.numberDone(at: selectedDate))\(" times".localized)/\
                    \(habit.achievement.targetTimes)\(" times".localized)
                    """)
                    .foregroundColor(habit.color)
                    .headline()
                Spacer()
            }
            LinearProgressBar(
                color: habit.color,
                progress: habit.achievement.progress(at: selectedDate)
            )
            Divider()
                .padding(.vertical, 8)
            HStack(spacing: 15) {
                IconButton(imageName: "minus") {
                    move(isAdd: false)
                }
                if habit.achievement.isSet {
                    Divider()
                        .frame(height: ButtonSize.small.rawValue)
                    TextButton(content: {
                        Text(isSetMode ? "±\(habit.achievement.addUnit)" : "±1")
                    }) {
                        isSetMode.toggle()
                    }
                }
                Divider()
                    .frame(height: ButtonSize.small.rawValue)
                TertiaryButton(content: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Achievement")
                    }
                }, action: {
                    move(isAdd: true)
                })
            }
            .padding(.bottom, 5)
        }
        .rowBackground(innerBottomPadding: false)
    }
    
    func move(isAdd: Bool) {
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

struct DailyProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DailyProgressBar(selectedDate: Date(), isEmojiMode: .constant(false))
            .environmentObject(FlHabit.sample(number: 0))
    }
}
