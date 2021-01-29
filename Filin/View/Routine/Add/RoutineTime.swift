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
            HStack {
                Text("Use reminder".localized)
                    .bodyText()
                Spacer()
                if isTimer {
                    DatePicker("", selection: $routineTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .accentColor(ThemeColor.mainColor(colorScheme))
                }
                PaperToggle($isTimer)
            }
            .rowBackground()
        }
    }
}

struct RoutineTime_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        @State var routineTime = Date()
        @State var isTimer = false
        var body: some View {
            RoutineTime(routineTime: $routineTime, isTimer: $isTimer)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
