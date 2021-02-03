//
//  SummaryPreview.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/02.
//

import SwiftUI

struct SummaryPreview: View {
    
    @Binding var isSettingSheet: Bool
    @State var isCalendarExpanded = false
    
    var body: some View {
        Group {
            HabitCalendar(
                selectedDate: .constant(Date()), isEmojiView: .constant(false),
                isCalendarExpanded: $isCalendarExpanded, habits: .init(contents: [FlHabit.habit1, FlHabit.habit2])
            )
            HabitRow(habit: FlHabit.habit1, showAdd: false)
            HabitRow(habit: FlHabit.habit2, showAdd: false)
        }
        .opacity(0.5)
        .disabled(true)
        Text("See information of goals at once.")
            .bodyText()
            .padding(.top, 34)
        MainRectButton(
            action: { isSettingSheet = true },
            str: "Select goals".localized
        )
        .padding(.top, 13)
    }
}

struct SummaryPreview_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPreview(isSettingSheet: .constant(false))
    }
}
