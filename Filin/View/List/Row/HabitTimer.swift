//
//  HabitTimer.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct HabitTimer: View {
    
    let date: Date
    let habit: FlHabit
    
    @State var timeRemaining = 0
    @State var isCounting = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HabitRow(habit: habit, showAdd: false)
                    .disabled(true)
                ZStack {
                    ZStack {
                        Circle()
                            .trim(
                                from: 0.0,
                                to: (CGFloat(habit.requiredSec)
                                        - CGFloat(timeRemaining))/CGFloat(habit.requiredSec)
                            )
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .square, lineJoin: .bevel))
                            .foregroundColor(habit.color)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                            .zIndex(1)
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .square, lineJoin: .bevel))
                            .subColor()
                            .zIndex(0)
                    }
                    VStack(spacing: 0) {
                        Text("\(timeRemaining)")
                            .title()
                            .mainColor()
                            .onReceive(timer) { _ in
                                guard isCounting else { return }
                                self.timeRemaining = max(0, self.timeRemaining - 1)
                            }
                            .onReceive(
                                NotificationCenter.default.publisher(
                                    for: UIApplication.willResignActiveNotification
                                )
                            ) { _ in
                                if !appSetting.backgroundTimer {
                                    isCounting = false
                                }
                                TimerManager.save(isCounting: isCounting, timeRemaining: timeRemaining)
                            }
                            .onReceive(
                                NotificationCenter.default.publisher(
                                    for: UIApplication.willEnterForegroundNotification
                                )
                            ) { _ in
                                (timeRemaining, isCounting) = TimerManager.sceneBack(appSetting)
                            }
                        Text("Sec".localized)
                            .headline()
                            .subColor()
                    }
                }
                .frame(width: 250, height: 250)
                .padding(.bottom, 30)
                HStack(alignment: .center, spacing: 60) {
                    Button(action: clearTimer) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .mainColor()
                            .title()
                    }
                    .frame(width: 50)
                    Button(action: {
                        if timeRemaining == 0 {
                            withAnimation {
                                habit.achievement.set(at: date) { current, addUnit in
                                    current + addUnit
                                }
                            }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            clearTimer()
                            return
                        }
                       toggleTimer()
                    }) {
                        Image(systemName: timeRemaining == 0 ? "plus" : (isCounting ? "pause" : "play"))
                            .mainColor()
                            .title()
                    }
                    .frame(width: 50)
                }
            }
            .padding(.top, 1)
        }
        .navigationBarTitle(Text(habit.name))
        .onAppear {
            TimerManager.set(id: habit.id)
            if TimerManager.isRunning {
                (timeRemaining, isCounting) = TimerManager.sceneBack(appSetting)
            } else {
                timeRemaining = habit.requiredSec
            }
        }
        .onDisappear {
            TimerManager.clear()
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
        isCounting = true
    }
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        isCounting = false
    }
    func clearTimer() {
        self.timer.upstream.connect().cancel()
        isCounting = false
        timeRemaining = habit.requiredSec
    }
    
    func toggleTimer() {
        if isCounting {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
}

struct HabitTimer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitTimer(date: Date(), habit: FlHabit(name: "Test", color: .blue, requiredSec: 3), timeRemaining: 3)
                .environmentObject(AppSetting())
        }
    }
}
