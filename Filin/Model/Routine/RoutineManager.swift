//
//  RoutineManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

class RoutineManager: DataBridge {
    
    typealias Converted = FlRoutine
    typealias Target = Routine
    
    @Published var contents: [FlRoutine] = []
    
    private init() {
        contents = fetched.map({FlRoutine($0, habitManager: HabitManager.shared)})
    }

    static var shared = RoutineManager()
    
    func append(_ object: Converted) {
        contents.append(object)
        object.addNoti { _ in }
    }
    
    private var deleteID: [UUID] = []
    
    func remove(withID: UUID) {
        guard let index = contents.firstIndex(where: {$0.id == withID}) else {
            assertionFailure("ID와 매칭되는 \(type(of: Converted.self)) 인스턴스가 없습니다.")
            return
        }
        contents[index].deleteNoti()
        contents.remove(at: index)
        deleteID.append(withID)
        for id in deleteID {
            if let habit = fetched.first(where: {$0.id == id}) {
                moc.delete(habit)
            }
        }
    }
    
    func save() {
        for flRoutine in contents {
            if let index = fetched.firstIndex(where: {$0.id == flRoutine.id}) {
                flRoutine.copyValues(to: fetched[index])
            } else {
                let newRoutine = Routine(context: moc)
                newRoutine.id = flRoutine.id
                flRoutine.copyValues(to: newRoutine)
            }
        }
        mocSave()
    }
}
