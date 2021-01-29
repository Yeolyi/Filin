//
//  TimerSection.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/27.
//

import SwiftUI

struct TimerSection: View {
    
    @Binding var time: Int
    @Environment(\.colorScheme) var colorScheme
    
    @State var _isRequiredTime = false
    var isRequiredTime: Binding<Bool> {
        Binding(get: {_isRequiredTime}, set: {
            _isRequiredTime = $0
            if $0 == false {
                time = 0
            }
        })
    }
    @State var _minute: Int = 0
    var minute: Binding<Int> {
        Binding(get: {_minute},
        set: {
            _minute = $0
            time = $0 * 60 + _second
        })
    }
    @State var _second: Int = 30
    var second: Binding<Int> {
        Binding(get: {_second},
        set: {
            _second = $0
            time = $0 * _minute * 60
        })
    }
    
    var body: some View {
        HabitAddBadgeView(title: "Timer".localized, imageName: "timer") {
            HStack {
                Text("Use a timer if you need a specific time to achieve your goal. E.g. two-minute plank.".localized)
                    .bodyText()
                    .padding(.bottom, 13)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 20)
            HStack {
                Text("Use timer".localized)
                    .bodyText()
                Spacer()
                PaperToggle(isRequiredTime)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            if isRequiredTime.wrappedValue {
                TimerPicker(minute: minute, second: second)
                    .rowPadding()
            }
        }
    }
}

struct TimerSection_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        
        @State var minute = 1
        @State var second = 30
        @State var isRequiredTime = false
        
        var body: some View {
            TimerSection(time: $minute)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
