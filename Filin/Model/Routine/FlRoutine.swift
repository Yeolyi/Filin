//
//  RoutineContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

class FlRoutine: CoreDataConvertable {
    
    let id: UUID
    @Published var name: String
    @Published var list: [FlHabit] = []
    @Published var time: Date?
    @Published var dayOfWeek: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    
    init(_ routine: Routine, habitManager: HabitManager) {
        id = routine.id
        name = routine.name
        list = routine.list.compactMap { id in
            habitManager.contents.first(where: {$0.id == id})
        }
        if let timeStr = routine.time {
            time = Date(hourAndMinuteStr: timeStr)
        }
        dayOfWeek = Set(routine.dayOfWeek.map(Int.init))
    }
    
    init(_ id: UUID, name: String) {
        self.id = id
        self.name = name
        dayOfWeek = [1, 2, 3, 4, 5, 6, 7]
    }
    
    init(copyExceptID: FlRoutine) {
        id = UUID()
        name = copyExceptID.name
        list = copyExceptID.list
        time = copyExceptID.time
        dayOfWeek = copyExceptID.dayOfWeek
    }
    
    func update(to routine: FlRoutine) {
        name = routine.name
        list = routine.list
        time = routine.time
        dayOfWeek = routine.dayOfWeek
        deleteNoti()
        addNoti(completion: {_ in})
    }
    
    func copyValues(to target: Routine) {
        guard target.id == id else {
            assertionFailure()
            return
        }
        target.name = name
        target.list = list.map(\.id)
        target.time = time?.hourAndMinuteStr
        target.dayOfWeek = Array(dayOfWeek).map(Int16.init)
    }
}

extension FlRoutine: Identifiable {
    static func == (lhs: FlRoutine, rhs: FlRoutine) -> Bool {
        lhs.id == rhs.id
    }
}

extension FlRoutine: Hashable {
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
}

extension Date {
    var hourAndMinuteStr: String {
        "\(hour)-\(minute)"
    }
    init(hourAndMinuteStr: String) {
        let split = hourAndMinuteStr.split(separator: "-").map {Int($0)!}
        guard split.count == 2 else {
            // assertionFailure()
            self = Date()
            return
        }
        self = Calendar.current.date(bySettingHour: split[0], minute: split[1], second: 0, of: Date())!
    }
}
