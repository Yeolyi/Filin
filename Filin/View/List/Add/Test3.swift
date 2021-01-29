//
//  Test3.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct TimesSection: View {
    
    @Binding var numberOfTimes: Int
    @Binding var addUnit: Int
    
    @State var _isSet = false
    var isSet: Binding<Bool> {
        Binding(get: { _isSet}, set: {
            _isSet = $0
            if $0 {
                addUnit = numberOfTimes
                _setNum = 1
            } else {
                addUnit = 1
            }
        })
    }

    @State var _setNum = 1
    var setNum: Binding<Int> {
        Binding(get: { _setNum }, set: {
            _setNum = $0
            numberOfTimes = $0 * addUnit
        })
    }
    
    var oneTapNum: Binding<Int> {
        Binding(get: {addUnit}, set: {
            addUnit = $0
            numberOfTimes = _setNum * $0
        })
    }
    
    var body: some View {
        HabitAddBadgeView(title: "Number of times".localized, imageName: "clock.arrow.2.circlepath") {
            Group {
                HStack {
                    Text("Split into sets".localized)
                        .bodyText()
                    Spacer()
                    PaperToggle(isSet)
                }
                if !isSet.wrappedValue {
                    PickerWithButton(
                        str: "How many times do you want to achieve your goal in a day?".localized,
                        size: 100, number: $numberOfTimes
                    )
                } else {
                    PickerWithButton(
                        str: "How many times do you proceed in one set?".localized,
                        size: 100, number: oneTapNum
                    )
                    PickerWithButton(
                        str: "How many sets are there?".localized,
                        size: 30, number: setNum
                    )
                    Divider()
                    Text("Total: \(numberOfTimes)")
                        .headline()
                }
            }
            .rowPadding()
        }
    }
}

struct Test3_Previews: PreviewProvider {
    
    struct StateWrapper: View {
        
        @State var number = 10
        @State var oneTapUnit = 1
        
        var body: some View {
            TimesSection(numberOfTimes: $number, addUnit: $oneTapUnit)
        }
    }
    
    static var previews: some View {
        StateWrapper()
    }
}
