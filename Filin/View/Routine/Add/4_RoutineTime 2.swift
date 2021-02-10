//
//  2_RoutineTime.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct RoutineTime: View {
    
    @Binding var routineTime: Date
    @Binding var isTimer: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HabitAddBadgeView(title: "Reminder".localized, imageName: "clock.arrow.2.circlepath") {
            Text("Receive notifications at a specific time.".localized)
                .rowHeadline()
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Toggle("", isOn: $isTimer)
                .toggleStyle(
                    ColoredToggleStyle(
                        label: "Use reminder".localized,
                        onColor: ThemeColor.mainColor(colorScheme)
                    )
                )
                .padding(.horizontal, 10)
            if isTimer {
                HStack {
                    Text("Reminder time".localized)
                        .rowSubheadline()
                        .padding(.leading, 10)
                    Spacer()
                    DatePicker("", selection: $routineTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .accentColor(ThemeColor.mainColor(colorScheme))
                }
                .rowBackground()
            }
        }
    }
}

struct RoutineTime_Previews: PreviewProvider {
    static var previews: some View {
        RoutineTime(routineTime: .constant(Date()), isTimer: .constant(true))
    }
}
