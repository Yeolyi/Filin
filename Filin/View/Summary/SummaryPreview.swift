//
//  SummaryPreview.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct SummaryPreview: View {
    
    let isRing: Bool
    
    var body: some View {
        Group {
            if isRing {
                HabitCalendar(
                    selectedDate: .constant(Date()), isEmojiView: .constant(false),
                    isCalendarExpanded: .constant(false), habits: .init(contents: [FlHabit.habit1, FlHabit.habit2])
                )
            } else {
                HabitCalendarTable(
                    isExpanded: .constant(false), isEmojiView: .constant(false),
                    selectedDate: .constant(Date()), habits: .init(contents: [FlHabit.habit1, FlHabit.habit2])
                )
            }
        }
        .opacity(0.5)
        .disabled(true)
    }
}

struct SummaryPreview_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPreview(isRing: false)
    }
}
