//
//  CompatibilityTest.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/10.
//

import SwiftUI

class CheckVersionCompatability {
    
    static func addSample(habitManager: HabitManager, summaryManager: SummaryManager, routineManager: RoutineManager) {
        let habits: [FlHabit] = [0, 1, 2, 3].map { FlHabit.sample(number: $0) }
        habitManager.append(contentsOf: habits, summaryManager: summaryManager)
        routineManager.append(FlRoutine.sample(number: 0))
        routineManager.append(FlRoutine.sample(number: 1))
        habitManager.save()
        routineManager.save()
    }
    
    static func isDataPreservedOnVersionChange(habitManager: HabitManager, routineManager: RoutineManager) -> Bool {
        FlHabit.sampleCount == habitManager.contents.count &&
            FlRoutine.sampleCount == routineManager.contents.count &&
            habitManager.contents.enumerated().allSatisfy { index, value in
                FlHabit.sample(number: index) == value
            } &&
            routineManager.contents.enumerated().allSatisfy { index, value in
                FlRoutine.sample(number: index) == value
            }
    }
    
}
