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
        Binding(get: {_isRequiredTime}, set: {
            _isRequiredTime = $0
            if $0 == false {
                requiredSec = 0
            }
        })
    }
    
    @State var _isRequiredTime = false
    @State var _minute: Int
    
    var minute: Binding<Int> {
        Binding(get: {_minute},
                set: {
                    _minute = $0
                    requiredSec = $0 * 60 + _second
                })
    }
    @State var _second: Int
    var second: Binding<Int> {
        Binding(get: {_second},
                set: {
                    _second = $0
                    requiredSec = $0 + _minute * 60
                })
    }
    
    init(requiredSec: Binding<Int>) {
        self._requiredSec = requiredSec
        __minute = State(initialValue: requiredSec.wrappedValue/60)
        __second = State(initialValue: requiredSec.wrappedValue%60)
        __isRequiredTime = State(initialValue: requiredSec.wrappedValue != 0)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 3) {
                Text(isRequiredTime.wrappedValue ? "On".localized : "Off".localized)
                    .bodyText()
                Spacer()
                PaperToggle(isRequiredTime)
            }
            .flatRowBackground()
            if isRequiredTime.wrappedValue {
                FlTimePicker(minute: minute, second: second)
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
