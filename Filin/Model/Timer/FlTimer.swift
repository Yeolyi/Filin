//
//  FlTimer.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/07.
//

import SwiftUI

class FlTimer: ObservableObject {
    
    @Published var timeRemaining: Double = 0
    @Published var isCounting: Bool = false
    @Published var targetSecond: Int = 0
    var timer: Timer?
    var isComplete: Bool { timeRemaining <= 0 }
    let id: UUID
    
    init(habit: FlHabit) {
        id = habit.id
        targetSecond = habit.requiredSec
        timeRemaining = Double(habit.requiredSec)
        restore()
    }
    
    init(requiredSec: Int) {
        id = UUID()
        timeRemaining = Double(requiredSec)
        targetSecond = requiredSec
    }
    
    deinit { timer?.invalidate() }
    
    var progress: Double {
        timeRemaining / Double(targetSecond)
    }
    
    func restore() {
        if let saved = TimerStateSaver.saved(habitId: id) {
            (timeRemaining, isCounting) = saved
            if isCounting {
                start()
            } else {
                pause()
            }
        }
    }
    
    func backup() {
        TimerStateSaver.save(id: id, isCounting: isCounting, timeRemaining: timeRemaining)
    }
    
    private func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                self.timeRemaining = max(0, self.timeRemaining - 0.1)
            }
        }
        isCounting = true
    }
    
    private func pause() {
        timer?.invalidate()
        isCounting = false
    }
    
    func stop() {
        timer?.invalidate()
        timeRemaining = Double(targetSecond)
        isCounting = false
        TimerStateSaver.clearState(habitId: id)
    }
    
    func stop(withNewTargetSec newSec: Int) {
        timer?.invalidate()
        targetSecond = newSec
        timeRemaining = Double(targetSecond)
        isCounting = false
        TimerStateSaver.clearState(habitId: id)
    }
    
    func toggle() {
        if isCounting {
            pause()
        } else {
            start()
        }
    }
}
