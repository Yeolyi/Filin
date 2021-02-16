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
    
    @ObservedObject var timer: FlTimer
    @EnvironmentObject var appSetting: AppSetting
    
    var hour: Int {
        Int(
            (timer.timeRemaining - Double(minute*60 + second)) / 3600
        )
    }
    
    var minute: Int {
        Int(
            (timer.timeRemaining - Double(second))
                .truncatingRemainder(dividingBy: 3600) / 60
        )
    }
    
    var second: Int {
        Int(timer.timeRemaining.truncatingRemainder(dividingBy: 60))
    }
    
    init(date: Date, habit: FlHabit, offlineTime: Date?) {
        self.date = date
        self.habit = habit
        self.timer = FlTimer(habit: habit)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 40) {
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: 1 - CGFloat(timer.progress))
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
                        .animation(nil)
                        .title()
                        .onReceive(
                            NotificationCenter.default.publisher(
                                for: UIApplication.willResignActiveNotification
                            )
                        ) { _ in
                            timer.backup()
                        }
                        .onReceive(
                            NotificationCenter.default.publisher(
                                for: UIApplication.willEnterForegroundNotification
                            )
                        ) { _ in
                            timer.restore()
                        }
                    }
                    .padding(20)
                    .rowBackground()
                    HStack(alignment: .center, spacing: 60) {
                        Button(action: timer.stop) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .mainColor()
                                .headline()
                        }
                        .frame(width: 50)
                        Button(action: {
                            guard timer.isComplete else {
                                timer.toggle()
                                return
                            }
                            withAnimation { habit.achievement.set(at: date) { $0 + $1 } }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            timer.stop()
                            return
                        }) {
                            Image(systemName: timer.isComplete ? "plus" : (timer.isCounting ? "pause" : "play"))
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
            .onDisappear {
                timer.backup()
            }
            .onAppear {
                timer.restore()
            }
        }
    }
}

struct HabitTimer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitTimer(date: Date(), habit: FlHabit(name: "Test", color: .blue, requiredSec: 100), offlineTime: nil)
                .environmentObject(AppSetting())
        }
    }
}
