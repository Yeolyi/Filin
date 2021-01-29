//
//  HabitContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

class FlHabit: CoreDataConvertable {
    
    typealias Target = Habit
    typealias DateKey = String
    
    let id: UUID
    @Published var name: String
    @Published var dayOfWeek: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    @Published var color: Color = .blue
    @Published var achievement: Achievement
    @Published var dailyEmoji: [DateKey: String] = [:]
    @Published var requiredSec: Int = 0
    
    var isTimer: Bool {
        requiredSec > 0
    }
    
    var isDaily: Bool {
        dayOfWeek.count == 7
    }
    
    convenience init(_ habit: Habit, addUnit: Int) {
        self.init(habit)
        achievement.addUnit = addUnit
    }
    
    private init(_ target: Habit) {
        id = target.id
        name = target.name
        dayOfWeek = Set(target.dayOfWeek.map(Int.init))
        color = Color(hex: target.colorHex)
        achievement = Achievement(
            target.achievement.mapValues(Int.init),
            numberOfTimes: Int(target.numberOfTimes),
            addUnit: 0
        )
        dailyEmoji = target.dailyEmoji
        requiredSec = Int(target.requiredSecond)
    }
    
    init(
        id: UUID = UUID(), name: String, dayOfWeek: Set<Int> = [1, 2, 3, 4, 5, 6, 7],
        color: Color = Palette.Default.red.color, numberOfTimes: Int = 10, requiredSec: Int = 0
    ) {
        self.id = id
        self.name = name
        self.dayOfWeek = dayOfWeek
        self.color = color
        self.achievement = Achievement(numberOfTimes: numberOfTimes)
        self.requiredSec = requiredSec
    }
    
    func update(to habit: FlHabit) {
        self.name = habit.name
        self.dayOfWeek = habit.dayOfWeek
        self.color = habit.color
        self.achievement.numberOfTimes = habit.achievement.numberOfTimes
        self.requiredSec = habit.requiredSec
        self.achievement.addUnit = habit.achievement.addUnit
    }
    
    func isTodo(at dayOfWeekInt: Int) -> Bool {
        dayOfWeek.contains(dayOfWeekInt)
    }
    
    func copyValues(to target: Habit) {
        guard self.id == target.id else {
            assertionFailure()
            return
        }
        target.achievement = achievement.content.mapValues(Int16.init)
        target.colorHex = color.hex
        target.dailyEmoji = dailyEmoji
        target.dayOfWeek = dayOfWeek.map(Int16.init)
        target.name = name
        target.numberOfTimes = Int16(achievement.numberOfTimes)
        target.requiredSecond = Int16(requiredSec)
    }
}

extension FlHabit: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FlHabit: Identifiable {
    static func == (lhs: FlHabit, rhs: FlHabit) -> Bool {
        lhs.id == rhs.id
    }
}
