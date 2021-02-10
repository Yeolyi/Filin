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
        self.contents = contents
    }
    var count: Int {
        contents.count
    }
    var isEmpty: Bool {
        contents.isEmpty
    }
    subscript(index: Int) -> FlHabit? {
        guard index < contents.count else {
            return nil
        }
        return contents[index]
    }
}
