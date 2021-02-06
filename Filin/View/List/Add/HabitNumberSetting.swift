//
//  HabitNumberSetting.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/02.
//

import SwiftUI

struct HabitNumberSetting: View {
    
    @ObservedObject var tempHabit: FlHabit
    @State var _isSet = false
    
    var isSet: Binding<Bool> {
        Binding(get: { _isSet}, set: {
            _isSet = $0
            if $0 {
                tempHabit.achievement.addUnit = tempHabit.achievement.targetTimes
                _setNum = 1
            } else {
                tempHabit.achievement.addUnit = 1
            }
        })
    }
    
    @State var _setNum = 1
    var setNum: Binding<Int> {
        Binding(get: { _setNum }, set: {
            _setNum = $0
            tempHabit.achievement.targetTimes = $0 * tempHabit.achievement.addUnit
        })
    }
    
    var oneTapNum: Binding<Int> {
        Binding(get: {tempHabit.achievement.addUnit}, set: {
            tempHabit.achievement.addUnit = $0
            tempHabit.achievement.targetTimes = _setNum * $0
        })
    }
    
    init(_ targetHabit: FlHabit) {
        self.tempHabit = targetHabit
        __setNum = State(
            initialValue: targetHabit.achievement.addUnit != 1 ?
                targetHabit.achievement.targetTimes / targetHabit.achievement.addUnit : 1
        )
        __isSet = State(initialValue: targetHabit.achievement.addUnit != 1)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Split into sets".localized)
                    .bodyText()
                Spacer()
                PaperToggle(isSet)
            }
            Divider()
            if !isSet.wrappedValue {
                PickerWithButton(
                    str: "", size: 100, number: $tempHabit.achievement.targetTimes
                )
            } else {
                HStack {
                    PickerWithButton(
                        str: "Number of sets".localized, size: 30, number: setNum
                    )
                    PickerWithButton(
                        str: "Number of times per set".localized, size: 100, number: oneTapNum
                    )
                }
            }
        }
        .flatRowBackground()
    }
}

struct HabitNumberSetting_Previews: PreviewProvider {
    static var previews: some View {
        HabitNumberSetting(PreviewDataProvider.shared.habitManager.contents[0])
    }
}
