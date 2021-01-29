//
//  HabitTimer.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/22.
//

import SwiftUI

struct HabitTimer: View {
    
    @EnvironmentObject var habit: FlHabit
    let date: Date
    @State var timeRemaining = 0
    @State var isCounting = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HabitRow(habit: habit, showAdd: false)
                    .disabled(true)
                Spacer()
                ZStack {
                    Circle()
                        .foregroundColor(.clear)
                        .overlay(
                            ZStack {
                                Circle()
                                    .trim(
                                        from: 0.0,
                                        to: (CGFloat(habit.requiredSec)
                                                - CGFloat(timeRemaining))/CGFloat(habit.requiredSec)
                                    )
                                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .square, lineJoin: .bevel))
                                    .foregroundColor(habit.color)
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .animation(.linear)
                                    .zIndex(1)
                                Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .square, lineJoin: .bevel))
                                    .subColor()
                                    .zIndex(0)
                            }
                        )
                    VStack(spacing: 0) {
                        Text("\(timeRemaining)")
                            .title()
                            .mainColor()
                            .onReceive(timer) { _ in
                                guard isCounting else { return }
                                self.timeRemaining = max(0, self.timeRemaining - 1)
                            }
                            .onReceive(NotificationCenter.default.publisher(
                                        for: UIApplication.willResignActiveNotification)
                            ) { _ in
                                isCounting = false
                                self.timer.upstream.connect().cancel()
                            }
                        Text("Sec".localized)
                            .headline()
                            .subColor()
                    }
                }
                .frame(width: 250, height: 250)
                .fixedSize()
                HStack(alignment: .center, spacing: 60) {
                    Button(action: {
                        self.timer.upstream.connect().cancel()
                        isCounting = false
                        timeRemaining = habit.requiredSec
                    }) {
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
                        }
                        if isCounting {
                            self.timer.upstream.connect().cancel()
                        } else {
                            self.timer =
                                Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                        }
                        isCounting.toggle()
                    }) {
                        Image(systemName: timeRemaining == 0 ? "plus" : (isCounting ? "pause" : "play"))
                            .mainColor()
                            .title()
                    }
                    .frame(width: 50)
                }
                Spacer()
            }
            .padding(.top, 1)
        }
        .navigationBarTitle(Text(habit.name))
        .onAppear {
            timeRemaining = habit.requiredSec
        }
    }
    
}

struct HabitTimer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitTimer(date: Date())
                .environmentObject(FlHabit(name: "Test", color: .blue, requiredSec: 10))
        }
    }
}
