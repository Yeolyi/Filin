//
//  HabitManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI
import WidgetKit

final class HabitManager: CoreDataBridge {
    
    typealias CoreDataType = Habit
    typealias InAppType = FlHabit
    
    @Published private(set) var contents: [FlHabit] = []
    
    @AutoSave("addUnit", defaultValue: [:])
    var addUnit: [UUID: Int] {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
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
                flHabit.coreDataTransfer(to: fetched[index])
            } else {
                let newHabit = Habit(context: moc)
                newHabit.id = flHabit.id
                flHabit.coreDataTransfer(to: newHabit)
            }
            mocSave()
            widgetDataList.append(
                .init(
                    id: flHabit.id, name: flHabit.name,
                    numberOfTimes: flHabit.achievement.targetTimes,
                    current: flHabit.achievement.numberDone(at: AppSetting().mainDate),
                    colorHex: flHabit.color.hex, day: AppSetting().mainDate.day
                )
            )
        }
        WidgetBridge.todayAchievements = widgetDataList
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        for savedHabit in fetched where !contents.contains(where: {$0.id == savedHabit.id}) {
            moc.delete(savedHabit)
        }
    }
    
    // 의존성 주입!!?!
    func remove(withID: UUID, summary: TempSummary, routines: [FlRoutine]) {
        guard let index = contents.firstIndex(where: {$0.id == withID}) else {
            assertionFailure("ID와 매칭되는 \(type(of: InAppType.self)) 인스턴스가 없습니다.")
            return
        }
        contents.remove(at: index)
        if let index = summary.list.firstIndex(where: {$0 == withID}) {
            summary.list.remove(at: index)
        }
        for routine in routines {
            routine.list.removeAll(where: {
                withID == $0.id
            })
        }
    }
    
    func append(_ object: FlHabit, summaryManager: SummaryManager) {
        contents.append(object)
        guard !summaryManager.contents.isEmpty else {
            assertionFailure()
            return
        }
        summaryManager.contents[0].list.append(object.id)
    }
    
    func append(contentsOf object: [FlHabit], summaryManager: SummaryManager) {
        contents.append(contentsOf: object)
        guard !summaryManager.contents.isEmpty else {
            assertionFailure()
            return
        }
        summaryManager.contents[0].list.append(contentsOf: object.map(\.id))
    }
}
