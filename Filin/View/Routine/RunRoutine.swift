//
//  RunRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RunRoutine: View {
    
    @ObservedObject var routine: FlRoutine
    @ObservedObject var timer: FlTimer
    
    @State var habitCursor = 0
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appSetting: AppSetting
    
    init(routine: FlRoutine) {
        self.routine = routine
        guard !routine.list.isEmpty else {
            timer = FlTimer(requiredSec: 1)
            return
        }
        timer = FlTimer(requiredSec: routine.list[0].requiredSec)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HabitRow(habit: routine.list[habitCursor], showAdd: false)
                    .disabled(true)
                if habitCursor + 1 <= routine.list.count - 1 {
                    VStack(spacing: 0) {
                        ForEach(habitCursor + 1...min(habitCursor + 5, routine.list.count - 1), id: \.self) { index in
                            HabitRow(habit: routine.list[index], showAdd: false)
                                .opacity(0.2)
                                .disabled(true)
                        }
                    }
                }
                Spacer()
            }
            VStack {
                Spacer()
                Text("\(habitCursor)/\(routine.list.count)")
                    .headline()
                nextButton
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle(Text(routine.name))
    }
    
    var nextButton: some View {
        Button(action: {
            guard !routine.list[habitCursor].isTimerUsed || timer.isComplete else {
                timer.toggle()
                return
            }
            withAnimation {
                routine.list[habitCursor].achievement.set(at: appSetting.mainDate) { $0 + $1 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                guard habitCursor != routine.list.count - 1 else {
                    presentationMode.wrappedValue.dismiss()
                    return
                }
                withAnimation { habitCursor += 1 }
                timer.stop(withNewTargetSec: routine.list[habitCursor].requiredSec)
            }
        }) {
            ZStack {
                if routine.list[habitCursor].requiredSec != 0 {
                    if timer.isComplete {
                        Text(habitCursor == routine.list.count - 1 ? "Complete".localized : "Next".localized)
                            .foregroundColor(.white)
                            .zIndex(1)
                        Circle()
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                    } else {
                        Image(systemName: timer.isCounting ? "pause" : "play")
                            .headline()
                            .mainColor()
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(timer.progress))
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                    }
                } else {
                    Text(habitCursor == routine.list.count - 1 ? "Complete".localized : "Next".localized)
                        .foregroundColor(.white)
                        .zIndex(1)
                    Circle()
                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                }
                
            }
            .frame(width: 100, height: 100)
            .onDisappear { timer.stop() }
        }
    }
}

struct RunRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let routine = FlRoutine(name: "Test")
        routine.list = [FlHabit](repeating: FlHabit(name: "A", requiredSec: 10), count: 10)
        return RunRoutine(routine: routine).environmentObject(AppSetting())
    }
}
