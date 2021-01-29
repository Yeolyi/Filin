//
//  HabitManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI
import WidgetKit

final class HabitManager: DataBridge {
    
    typealias Target = Habit
    typealias Converted = FlHabit
    
    static var shared = HabitManager()
    private var deletedIDs: [UUID] = []
    
    @Published var contents: [FlHabit] = []
    
    @AutoSave("addUnit", defaultValue: [:])
    var addUnit: [UUID: Int] {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {
        contents = fetched.map { habit in
            if let unit = addUnit.first(where: {(key, _) in key == habit.id})?.value {
                return FlHabit.init(habit, addUnit: unit)
            } else {
                addUnit[habit.id] = 1
                return FlHabit.init(habit, addUnit: 1)
            }
        }
    }
    
    func save() {
        var widgetDataList: [HabitWidgetData] = []
        for flHabit in contents {
            addUnit[flHabit.id] = flHabit.achievement.addUnit
            if let index = fetched.firstIndex(where: {$0.id == flHabit.id}) {
                flHabit.copyValues(to: fetched[index])
            } else {
                let newHabit = Habit(context: moc)
                newHabit.id = flHabit.id
                flHabit.copyValues(to: newHabit)
            }
            widgetDataList.append(
                .init(
                    id: flHabit.id, name: flHabit.name,
                    numberOfTimes: flHabit.achievement.numberOfTimes,
                    current: flHabit.achievement.content[AppSetting().mainDate.dictKey] ?? 0,
                    colorHex: flHabit.color.hex, day: AppSetting().mainDate.day
                )
            )
        }
        WidgetBridge.todayAchievements = widgetDataList
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        mocSave()
        for id in deletedIDs {
            if let habit = fetched.first(where: {$0.id == id}) {
                moc.delete(habit)
            }
        }
    }
    
    // 의존성 주입!!?!
    func remove(withID: UUID, summary: FlSummary) {
        guard let index = contents.firstIndex(where: {$0.id == withID}) else {
            assertionFailure("ID와 매칭되는 \(type(of: Converted.self)) 인스턴스가 없습니다.")
            return
        }
        contents.remove(at: index)
        deletedIDs.append(withID)
        if summary.first == withID {
            summary.first = nil
        }
        if summary.second == withID {
            summary.second = nil
        }
        if summary.third == withID {
            summary.third = nil
        }
    }
    
    func append(_ object: FlHabit) {
        contents.append(object)
    }
}
