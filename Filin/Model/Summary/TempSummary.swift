//
//  Summary.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI
import CoreData

final class TempSummary: CoreDataConvertable {
    
    typealias Target = FlSummary
    
    let id: UUID
    @Published var name: String
    @Published var list: [UUID]
    
    init(name: String, list: [UUID], id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.list = list
    }
    
    init(_ coreData: FlSummary) {
        self.id = coreData.id
        self.name = coreData.name
        self.list = coreData.list
    }
    
    func copyValues(to target: FlSummary) {
        guard target.id == id else {
            assertionFailure()
            return
        }
        target.list = list
        target.name = name
    }
}
