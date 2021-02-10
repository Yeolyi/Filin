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
    
    init() {
        contents = fetched.map { TempSummary($0) }
        if contents.isEmpty {
            contents.append(.init())
        }
    }
    
    func setList(_ list: [UUID]) {
        contents[0].list = list
    }
    
    func save() {
        let flSummary = contents[0]
        if let index = fetched.firstIndex(where: {$0.id == flSummary.id}) {
            flSummary.coreDataTransfer(to: fetched[index])
        } else {
            let newHabit = FlSummary(context: moc)
            newHabit.id = flSummary.id
            flSummary.coreDataTransfer(to: newHabit)
        }
        mocSave()
    }
}
