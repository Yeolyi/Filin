//
//  RingGroup.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/24.
//

import SwiftUI

struct Ring: Hashable {
    var progress: Double
    var color: Color
    init(_ progress: Double, _ color: Color) {
        self.progress = progress
        self.color = color
    }
}

struct RingGroup {
    var content: [Ring?]
    init(_ rings: [Ring?]) {
        guard rings.count <= 3 else {
            assertionFailure()
            content = []
            return
        }
        if rings.count < 3 {
            content = rings + [Ring?](repeating: nil, count: 3 - rings.count)
        } else {
            content = rings
        }
    }
    subscript(index: Int) -> (progress: Double, color: Color) {
        guard index <= 2 else {
            assertionFailure()
            return (0.0, .clear)
        }
        if let ring = content[index] {
            return (ring.progress, ring.color)
        } else {
            return (0.0, .clear)
        }
    }
    subscript(raw index: Int) -> (progress: Double, color: Color)? {
        guard index <= 2, let ring = content[index] else {
            return nil
        }
        return (ring.progress, ring.color)
    }
    var isEmpty: Bool {
        content.filter({($0?.color ?? .clear) != .clear}).isEmpty
    }
    var nilConverted: [Ring] {
        content.compactMap { ring in
            ring == nil ? Ring(0.0, .clear) : ring!
        }
    }
}
