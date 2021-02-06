//
//  Summary.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/03.
//

import SwiftUI
import CoreData

final class TempSummary: CoreDataConvertable {
    
    typealias MatchingCoreDataType = FlSummary
    
    let id: UUID
    @Published var name: String
    @Published var list: [UUID]
    
    init(name: String = "Default") {
        self.id = UUID()
        self.name = name
        self.list = []
    }
    
    init(_ coreData: FlSummary) {
        self.id = coreData.id
        self.name = coreData.name
        self.list = coreData.list
    }
    
    func coreDataTransfer(to target: FlSummary) {
        guard target.id == id else {
            assertionFailure()
            return
        }
        target.list = list
        target.name = name
    }
    
    static func makeSample(usingIDs idArr: [UUID]) -> TempSummary {
        let sample = TempSummary()
        sample.list = idArr
        return sample
    }
    
}
