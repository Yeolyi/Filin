//
//  RunRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RunRoutine: View {
    
    @ObservedObject var routine: FlRoutine
    
    @State var currentListIndex = 0
    @State var isTimeInit = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 0
    @State var isCounting = false
    
    var isComplete: Bool {
        timeRemaining == 0
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HabitRow(habit: routine.list[currentListIndex], showAdd: false)
                    .disabled(true)
                if currentListIndex < routine.list.count - 1 {
                    VStack(spacing: 0) {
                        ForEach(currentListIndex + 1...routine.list.count - 1, id: \.self) { index in
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
                Text("\(currentListIndex)/\(routine.list.count)")
                    .headline()
                nextButton
                    .padding(.bottom, 50)
                    .onReceive(timer) { _ in
                        guard isCounting else { return }
                        withAnimation {
                            self.timeRemaining = max(0, self.timeRemaining - 1)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(
                                for: UIApplication.willResignActiveNotification)
                    ) { _ in
                        isCounting = false
                        self.timer.upstream.connect().cancel()
                    }
            }
        }
        .navigationBarTitle(Text(routine.name))
        .onAppear {
            if !isTimeInit {
                timeRemaining = routine.list[0].requiredSec
                isTimeInit = true
            }
        }
    }
    
    var nextButton: some View {
        Button(action: {
            if routine.list[currentListIndex].requiredSec != 0 && timeRemaining != 0 {
                if isCounting {
                    self.timer.upstream.connect().cancel()
                } else {
                    self.timer =
                        Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                }
                isCounting.toggle()
                return
            } else {
                self.timer.upstream.connect().cancel()
                isCounting = false
                withAnimation {
                    routine.list[currentListIndex].achievement.set(at: Date()) { current, addUnit in
                        current + addUnit
                    }
                    routine.objectWillChange.send()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    if currentListIndex == routine.list.count - 1 {
                        presentationMode.wrappedValue.dismiss()
                        return
                    }
                    withAnimation {
                        currentListIndex += 1
                    }
                    timeRemaining = routine.list[currentListIndex].requiredSec
                }
            }
        }) {
            ZStack {
                if routine.list[currentListIndex].requiredSec != 0 {
                    if timeRemaining == 0 {
                        Text(currentListIndex == routine.list.count - 1 ? "Complete".localized : "Next".localized)
                            .foregroundColor(.white)
                            .zIndex(1)
                        Circle()
                            .foregroundColor(ThemeColor.mainColor(colorScheme))
                            .frame(width: 100, height: 100)
                    } else if isCounting {
                        Image(systemName: "pause")
                            .headline()
                            .mainColor()
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(
                                        from: 0.0,
                                        to: CGFloat(timeRemaining)/CGFloat(routine.list[currentListIndex].requiredSec)
                                    )
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    } else {
                        Image(systemName: "play")
                            .headline()
                            .mainColor()
                            .zIndex(1)
                        Circle()
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .trim(
                                        from: 0.0,
                                        to: CGFloat(timeRemaining)/CGFloat(routine.list[currentListIndex].requiredSec)
                                    )
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .square, lineJoin: .bevel))
                                    .mainColor()
                                    .rotationEffect(Angle(degrees: 270.0))
                            )
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Text(currentListIndex == routine.list.count - 1 ? "Complete".localized : "Next".localized)
                        .foregroundColor(.white)
                        .zIndex(1)
                    Circle()
                        .foregroundColor(ThemeColor.mainColor(colorScheme))
                        .frame(width: 100, height: 100)
                }
                
            }
        }
    }
}

struct RunRoutine_Previews: PreviewProvider {
    static var previews: some View {
        RunRoutine(routine: FlRoutine.routine1)
    }
}
