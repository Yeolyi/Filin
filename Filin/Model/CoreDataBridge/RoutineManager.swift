//
//  RoutineManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

class RoutineManager: CoreDataBridge {
    
    typealias InAppType = FlRoutine
    typealias CoreDataType = Routine
    
    @Published var contents: [FlRoutine] = []
    
    init() {
        contents = fetched.map({FlRoutine($0, habitManager: HabitManager())})
    }

    func todoRoutines(at dayOfWeek: Int) -> [FlRoutine] {
        contents.filter({$0.isTodo(at: dayOfWeek)})
    }
    
    func otherRoutines(at dayOfWeek: Int) -> [FlRoutine] {
        contents.filter({!$0.isTodo(at: dayOfWeek)})
    }
    
    func append(_ object: InAppType) {
        contents.append(object)
        object.addNoti { _ in }
    }
    
    func append(contentsOf routines: [FlRoutine]) {
        for routine in routines {
            contents.append(routine)
            routine.addNoti { _ in }
        }
    }
    
    func remove(withID: UUID) {
        guard let index = contents.firstIndex(where: {$0.id == withID}) else {
            assertionFailure("ID와 매칭되는 \(type(of: InAppType.self)) 인스턴스가 없습니다.")
            return
        }
        contents[index].deleteNoti()
        contents.remove(at: index)
    }
    
    func save() {
        for flRoutine in contents {
            if let index = fetched.firstIndex(where: {$0.id == flRoutine.id}) {
                flRoutine.coreDataTransfer(to: fetched[index])
            } else {
                let newRoutine = Routine(context: moc)
                newRoutine.id = flRoutine.id
                flRoutine.coreDataTransfer(to: newRoutine)
            }
            mocSave()
        }
        for savedRoutine in fetched where !contents.contains(where: {$0.id == savedRoutine.id}) {
            moc.delete(savedRoutine)
        }
    }
}
