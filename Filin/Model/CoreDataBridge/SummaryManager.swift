//
//  SummaryManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

final class SummaryManager: CoreDataBridge {
    
    typealias InAppType = TempSummary
    typealias CoreDataType = FlSummary
    
    @Published var contents: [TempSummary] = []
    
    static var shared = SummaryManager()
    
    private init() {
        contents = fetched.map { TempSummary($0) }
        if contents.isEmpty {
            contents.append(.init())
        }
    }
    
    func save() {
        for flSummary in contents {
            if let index = fetched.firstIndex(where: {$0.id == flSummary.id}) {
                flSummary.coreDataTransfer(to: fetched[index])
            } else {
                let newHabit = FlSummary(context: moc)
                newHabit.id = flSummary.id
                flSummary.coreDataTransfer(to: newHabit)
            }
        }
        mocSave()
    }
    
    func append(_ object: InAppType) {
        contents.append(object)
    }
    
    func remove(withID: UUID) {
        assertionFailure()
    }
    
}
