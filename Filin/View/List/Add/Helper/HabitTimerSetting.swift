//
//  HabitTimerSetting.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/02.
//

import SwiftUI

struct HabitTimerSetting: View {
    
    @Binding var requiredSec: Int
    var isRequiredTime: Binding<Bool> {
        Binding(
            get: {
                requiredSec != 0
            }, set: {
                if $0 {
                    requiredSec = timerBackup == 0 ? 1 : timerBackup
                } else {
                    timerBackup = requiredSec
                    requiredSec = 0
                }
            }
        )
    }
    @State var timerBackup = 0
    
    init(requiredSec: Binding<Int>) {
        self._requiredSec = requiredSec
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 3) {
                Text(isRequiredTime.wrappedValue ? "On".localized : "Off".localized)
                    .bodyText()
                Spacer()
                FlToggle(isRequiredTime)
            }
            .frame(maxWidth: .infinity)
            .flatRowBackground()
            if isRequiredTime.wrappedValue {
                FlTimePicker(requiredSec: $requiredSec)
                    .frame(maxWidth: .infinity)
                    .flatRowBackground()
            }
        }
    }
}

struct HabitTimerSetting_Previews: PreviewProvider {
    static var previews: some View {
        HabitTimerSetting(requiredSec: .constant(10))
    }
}
