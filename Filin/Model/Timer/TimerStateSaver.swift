//
//  TimerStateSaver.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/10.
//

import Foundation

struct TimerStateSaver {
    
    struct TimerState: Codable {
        let isCounting: Bool
        let timeRemaining: Double
        let offlineTime: Date
    }
    
    @AutoSave("timerStates", defaultValue: [:])
    private static var timerStates: [UUID: TimerState]
    
    static func clearState(habitId: UUID) {
        timerStates[habitId] = nil
    }
    
    static func save(id: UUID, isCounting: Bool, timeRemaining: Double) {
        timerStates[id] = .init(isCounting: isCounting, timeRemaining: timeRemaining, offlineTime: Date())
    }
    
    static func saved(habitId: UUID) -> (timeRemaining: Double, isCounting: Bool)? {
        guard let timerState = timerStates[habitId] else {
            return nil
        }
        if timerState.isCounting {
            let difference = Double(Date().timeIntervalSince(timerState.offlineTime))
            return (max(timerState.timeRemaining - difference, 0), timerState.isCounting)
        } else {
            return (timerState.timeRemaining, timerState.isCounting)
        }
    }
}
