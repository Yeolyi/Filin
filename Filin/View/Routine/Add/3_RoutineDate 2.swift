//
//  RoutineDate.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI

struct RoutineDate: View {
    
    @Binding var dayOfTheWeek: [Int]
    
    var body: some View {
        HabitAddBadgeView(title: "Repeat".localized, imageName: "calendar") {
            Text("Choose the day of the week to proceed with the routine.".localized)
                .rowHeadline()
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
            DayOfWeekSelector(dayOfTheWeek: $dayOfTheWeek)
        }
    }
}

struct RoutineDate_Previews: PreviewProvider {
    static var previews: some View {
        RoutineDate(dayOfTheWeek: .constant([1, 2, 3, 4, 5, 6, 7]))
    }
}
