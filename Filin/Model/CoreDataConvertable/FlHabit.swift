//
//  HabitContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

class FlHabit: CoreDataConvertable {
    
    typealias MatchingCoreDataType = Habit
    typealias DateKey = String
    
    private static let sampleData: [
        (name: String, color: Color, dayOfWeek: Set<Int>, numberOfTimes: Int, requiredSec: Int)
    ] = [
        ("Intermediate Stretching🙆‍♀️".localized, Palette.Default.red.color, [1, 2, 3, 4, 5, 6, 7], 8, 10),
        ("10-Minute Walk🚶".localized, Palette.Default.pink.color, [1, 3, 5], 3, 600),
        ("Drinking 2L Water💧".localized, Palette.Default.blue.color, [1, 2, 3, 4, 5, 6, 7], 8, 0),
        ("10 minutes of meditation🧘".localized, Palette.Default.purple.color, [1, 2, 3, 4, 5, 6, 7], 2, 0)
    ]
    
    /// - Todo: AppSetting을 입력받아 보다 정확한 achievement 추가,,,,,ㅁㅇ,ㅁㄴ미퍼모ㅑㄹ
    static func sample(number index: Int) -> FlHabit {
        guard index < sampleData.count else {
            assertionFailure()
            return sample(number: 0)
        }
        let habitData = sampleData[index]
        let habit = FlHabit(
            name: habitData.name, dayOfWeek: habitData.dayOfWeek, color: habitData.color, numberOfTimes:
                habitData.numberOfTimes, requiredSec: habitData.requiredSec
        )
        habit.achievement.addSampleContentForDebug(to: Date())
        return habit
    }
    
    let id: UUID
    @Published var name: String
    @Published var dayOfWeek: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    @Published var color: Color = .blue
    @Published var achievement: Achievement
    @Published var dailyEmoji: [DateKey: String] = [:]
    @Published var requiredSec: Int = 0
    var copyID: UUID?
    
    var isTimerUsed: Bool { requiredSec > 0 }
    
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
            numberOfTimes: Int(target.numberOfTimes),
            addUnit: 1
        )
        achievement.setContentFromCoreData(target.achievement.mapValues(Int.init))
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
    
    var copy: FlHabit {
        copyID = UUID()
        return FlHabit(
            id: copyID!, name: name, dayOfWeek: dayOfWeek, color: color,
            numberOfTimes: achievement.targetTimes, requiredSec: requiredSec
        )
    }
    
    func applyChanges(copy habit: FlHabit) {
        guard copyID == habit.id else {
            assertionFailure()
            return
        }
        self.name = habit.name
        self.dayOfWeek = habit.dayOfWeek
        self.color = habit.color
        self.achievement.addUnit = habit.achievement.addUnit
        self.achievement.targetTimes = habit.achievement.targetTimes
        self.requiredSec = habit.requiredSec
        copyID = nil
    }
    
    func isTodo(at dayOfWeekInt: Int) -> Bool {
        dayOfWeek.contains(dayOfWeekInt)
    }
    
    func coreDataTransfer(to target: Habit) {
        guard self.id == target.id else {
            assertionFailure()
            return
        }
        target.achievement = achievement.contentForCoreData
        target.colorHex = color.hex
        target.dailyEmoji = dailyEmoji
        target.dayOfWeek = dayOfWeek.map(Int16.init)
        target.name = name
        target.numberOfTimes = Int16(achievement.targetTimes)
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
