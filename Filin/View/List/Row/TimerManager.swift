//
//  TimerManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/30.
//

import SwiftUI

struct TimerManager {
    
    @AutoSave("timerHabitID", defaultValue: nil)
    private static var timerHabitId: UUID?
    
    @AutoSave("isCounting", defaultValue: false)
    private static var isCounting: Bool
    
    @AutoSave("timeRemaining", defaultValue: 0)
    private static var timeRemaining: Int
    
    static func set(id: UUID) {
        timerHabitId = id
    }

    static func clear() {
        timerHabitId = nil
    }
    
    static var isRunning: Bool {
        timerHabitId != nil
    }
    
    static func save(isCounting: Bool, timeRemaining: Int) {
        guard timerHabitId != nil else {
            assertionFailure()
            return
        }
        self.isCounting = isCounting
        self.timeRemaining = timeRemaining
    }
    
    static func sceneBack(_ appSetting: AppSetting) -> (timeRemaining: Int, isCounting: Bool) {
        if isCounting {
            let difference = Int(Date().timeIntervalSince(appSetting.sceneBackgroundTime ?? Date()))
            return (max(timeRemaining - difference, 0), isCounting)
        } else {
            return (timeRemaining, isCounting)
        }
    }
    
    static func habit(_ habitManager: HabitManager) -> FlHabit? {
        guard let id = timerHabitId else {
            return nil
        }
        if let habit = habitManager.contents.first(where: { $0.id == id }) {
            return habit
        } else {
            return nil
        }
    }
}
