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
    
    @State var timeRemaining = 0.0
    @State var isCounting = false
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var appSetting: AppSetting
    
    var hour: Int {
        Int(
            (timeRemaining - Double(minute*60 + second)) / 3600
        )
    }
    
    var minute: Int {
        Int(
            (timeRemaining - Double(second))
                .truncatingRemainder(dividingBy: 3600) / 60
        )
    }
    
    var second: Int {
        Int(timeRemaining.truncatingRemainder(dividingBy: 60))
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 40) {
                    ZStack {
                        Circle()
                            .trim(
                                from: 0.0,
                                to: (CGFloat(habit.requiredSec)
                                        - CGFloat(timeRemaining))/CGFloat(habit.requiredSec)
                            )
                            .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round))
                            .frame(width: geo.size.width - 100, height: geo.size.width - 100)
                            .foregroundColor(habit.color)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                            .zIndex(1)
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .square, lineJoin: .bevel))
                            .frame(width: geo.size.width - 100, height: geo.size.width - 100)
                            .subColor()
                            .zIndex(0)
                        Text(
                            (hour != 0 ? "\(String(format: "%02d", hour)) : " : "")
                            +
                            String(format: "%02d", minute) +
                            " : " +
                            String(format: "%02d", second)
                        )
                            .foregroundColor(habit.color)
                            .title()
                            .onReceive(timer) { _ in
                                guard isCounting else { return }
                                self.timeRemaining = max(0, self.timeRemaining - 0.1)
                            }
                            .onReceive(
                                NotificationCenter.default.publisher(
                                    for: UIApplication.willResignActiveNotification
                                )
                            ) { _ in
                                TimerManager.save(isCounting: isCounting, timeRemaining: timeRemaining)
                            }
                            .onReceive(
                                NotificationCenter.default.publisher(
                                    for: UIApplication.willEnterForegroundNotification
                                )
                            ) { _ in
                                (timeRemaining, isCounting) = TimerManager.sceneBack(appSetting)
                            }
                    }
                    .padding(20)
                    .rowBackground()
                    HStack(alignment: .center, spacing: 60) {
                        Button(action: clearTimer) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .mainColor()
                                .headline()
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
                            Image(systemName: timeRemaining <= 0 ? "plus" : (isCounting ? "pause" : "play"))
                                .mainColor()
                                .headline()
                        }
                        .frame(width: 50)
                    }
                    .flatRowBackground()
                }
                .padding(.top, 20)
            }
            .padding(.top, 1)
            .offset(x: 5)
            .navigationBarTitle(Text(habit.name))
        }
        .onAppear {
            if TimerManager.isRunning {
                (timeRemaining, isCounting) = TimerManager.sceneBack(appSetting)
            } else {
                timeRemaining = Double(habit.requiredSec)
            }
            TimerManager.set(id: habit.id)
        }
        .onDisappear {
            TimerManager.clear()
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
        isCounting = true
    }
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        isCounting = false
    }
    func clearTimer() {
        self.timer.upstream.connect().cancel()
        isCounting = false
        timeRemaining = Double(habit.requiredSec)
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
            HabitTimer(date: Date(), habit: FlHabit(name: "Test", color: .blue, requiredSec: 10000), timeRemaining: 3)
                .environmentObject(AppSetting())
        }
    }
}
