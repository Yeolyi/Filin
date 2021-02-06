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
        HabitCalendar(
            selectedDate: .constant(Date()), isEmojiView: .constant(false),
            isExpanded: .constant(false), habits: .init(contents: [
                FlHabit.sample(number: 1), FlHabit.sample(number: 2)
            ])
        )
        .opacity(0.5)
        .disabled(true)
    }
}

struct SummaryPreview_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPreview(isRing: false)
    }
}
