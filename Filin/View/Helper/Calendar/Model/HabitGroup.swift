//
//  HabitGroup.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/01.
//

import SwiftUI

class HabitGroup: ObservableObject {
    @Published var contents: [FlHabit]
    init(contents: [FlHabit]) {
        guard !contents.isEmpty else {
            assertionFailure()
            self.contents = []
            return
        }
        self.contents = contents
    }
    var count: Int {
        contents.count
    }
    var isEmpty: Bool {
        contents.isEmpty
    }
    subscript(index: Int) -> FlHabit {
        contents[index]
    }
}
