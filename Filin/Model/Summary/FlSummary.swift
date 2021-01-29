//
//  SummaryContext.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

final class FlSummary: CoreDataConvertable {
    
    typealias Target = Summary
    
    let id: UUID
    @Published var name: String
    @Published var first: UUID?
    @Published var second: UUID?
    @Published var third: UUID?
    
    var habitArray: [UUID?] {
        [first, second, third]
    }
    
    var isEmpty: Bool {
        habitArray.compactMap({$0}).isEmpty
    }
    
    init(_ summary: Summary) {
        id = summary.id
        name = summary.name
        first = summary.first
        second = summary.second
        third = summary.third
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    subscript(index: Int) -> UUID? {
        get {
            switch index {
            case 1: return first
            case 2: return second
            case 3: return third
            default:
                assertionFailure()
                return first
            }
        }
        set {
            switch index {
            case 1: first = newValue
            case 2: second = newValue
            case 3: third = newValue
            default:
                assertionFailure()
            }
        }
    }
    
    func copyValues(to target: Summary) {
        guard target.id == id else {
            assertionFailure()
            return
        }
        target.first = first
        target.second = second
        target.third = third
        target.name = name
    }
    
}

extension FlSummary: Identifiable {
    
}
