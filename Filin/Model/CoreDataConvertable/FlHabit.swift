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
    
    @AutoSave("habitSampleAchievements", defaultValue: [])
    private static var habitSampleAchievements: [[DateKey: Int]]
    
    @AutoSave("habitSampleIDs", defaultValue: [])
    private static var habitSampleIDs: [UUID]
    
    /// - Todo: AppSetting을 입력받아 보다 정확한 achievement 추가,,,,,ㅁㅇ,ㅁㄴ미퍼모ㅑㄹ
    static func sample(number index: Int) -> FlHabit {
        guard index < sampleData.count else {
            assertionFailure()
            return sample(number: 0)
        }
        if habitSampleAchievements.count != sampleCount {
            initSampleAchievement()
        }
        let habitData = sampleData[index]
        let habit = FlHabit(
            id: habitSampleIDs[index], name: habitData.name, dayOfWeek: habitData.dayOfWeek, color: habitData.color, numberOfTimes:
                habitData.numberOfTimes, requiredSec: habitData.requiredSec
        )
        habit.achievement.setContentForDebug(using: habitSampleAchievements[index])
        return habit
    }
    
    private static func initSampleAchievement() {
        print("asdad")
        habitSampleAchievements = Array(0..<sampleCount).map { sampleIndex in
            Array(-200...0).map { dateDiff in
                Date().addDate(dateDiff)!
            }.reduce(into: [:]) { result, value in
                result[value.dictKey] = Int.random(in: 0...sampleData[sampleIndex].numberOfTimes)
            }
        }
        habitSampleIDs = Array(0..<sampleCount).map { _ in UUID() }
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
    
    static var sampleCount: Int { sampleData.count }
    
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
        achievement.setContentFromCoreData(target.achievement)
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
    static func == (lhs: FlHabit, rhs: FlHabit) -> Bool {
        lhs.name == rhs.name &&
            lhs.dayOfWeek == rhs.dayOfWeek &&
            lhs.color == rhs.color &&
            lhs.achievement == rhs.achievement &&
            lhs.dailyEmoji == rhs.dailyEmoji &&
            lhs.requiredSec == rhs.requiredSec
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
