//
//  RowData.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI

class RowData<Value: Hashable>: ObservableObject {
    
    init(_ id: UUID, _ value: Value, _ yPosition: CGFloat) {
        self.id = id
        self.value = value
        self.yPosition = yPosition
    }
    
    var id: UUID
    var value: Value
    @Published var yPosition: CGFloat
    @Published var isTapped = false
    @Published var offset: CGFloat = 0
    
    var position: CGFloat {
        return yPosition + offset
    }

}

extension RowData: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RowData, rhs: RowData) -> Bool {
        lhs.id == rhs.id
    }
    
}
