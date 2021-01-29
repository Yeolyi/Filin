//
//  Test2.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct DateSection: View {
    @Binding var dayOfTheWeek: Set<Int>
    var body: some View {
        HabitAddBadgeView(title: "Repeat".localized, imageName: "calendar") {
            HStack {
                Text("Choose the day of the week to proceed with the goal.".localized)
                    .bodyText()
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.leading, 20)
            DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
                .padding(.top, 21)
        }
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        DateSection(dayOfTheWeek: .constant([]))
    }
}
