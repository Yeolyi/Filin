//
//  Tile.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/01.
//

import SwiftUI

struct Tile: View {
    
    let date: Date
    let selectedDate: Date
    let isExpanded: Bool
    @ObservedObject var habits: HabitGroup
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .foregroundColor(
                        (date.month == selectedDate.month) || !isExpanded ?
                            (habits[0]?.color ?? .gray) : ThemeColor.inActive(colorScheme)
                    )
                    .opacity(habits[0]?.achievement.progress(at: date) ?? 0)
            }
            if date.month != selectedDate.month && isExpanded {
                Text("\(date.day)")
                    .inactiveColor()
                    .bodyText()
            } else {
                Text("\(date.day)")
                    .if(date.dictKey == selectedDate.dictKey) {
                        $0.font(.system(size: 16, weight: .heavy))
                    }
                    .bodyText()
                    .opacity(0.8)
            }
        }
        .frame(width: 40, height: 40)
        .animation(.default)
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = PreviewDataProvider.shared
        return Tile(
            date: Date(), selectedDate: Date(), isExpanded: false,
            habits: .init(contents: [dataSample.habitManager.contents[0]])
        )
    }
}
