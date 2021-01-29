//
//  SummaryManager.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

final class SummaryManager: DataBridge {
    
    typealias Converted = FlSummary
    typealias Target = Summary
    
    @Published var contents: [FlSummary] = []
    
    static var shared = SummaryManager()
    
    private init() {
        contents = fetched.map { FlSummary.init($0) }
        if contents.isEmpty {
            contents.append(.init(id: UUID(), name: "Default"))
        }
    }
    
    func save() {
        for flSummary in contents {
            if let index = fetched.firstIndex(where: {$0.id == flSummary.id}) {
                flSummary.copyValues(to: fetched[index])
            } else {
                let newHabit = Summary(context: moc)
                newHabit.id = flSummary.id
                flSummary.copyValues(to: newHabit)
            }
        }
        mocSave()
    }
    
    func append(_ object: Converted) {
        contents.append(object)
    }
    
    func remove(withID: UUID) {
        assertionFailure()
    }
    
}
