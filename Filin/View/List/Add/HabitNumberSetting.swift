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
                targetHabit.achievement.targetTimes / targetHabit.achievement.addUnit : targetHabit.achievement.targetTimes
        )
        __isSet = State(initialValue: targetHabit.achievement.addUnit != 1)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            if !isSet.wrappedValue {
                Picker("", selection: setNum) {
                    ForEach(1...100, id: \.self) { num in
                        Text(String(num))
                            .bodyText()
                    }
                }
                .frame(width: 150, height: 150)
                .clipped()
            } else {
                HStack {
                    VStack {
                        Picker("", selection: setNum) {
                            ForEach(1...30, id: \.self) { num in
                                Text(String(num))
                                    .bodyText()
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        .accessibility(identifier: "numberOfSets")
                        Text("Number of Sets".localized)
                            .subColor()
                            .font(.system(size: FontSize.caption.rawValue, weight: .semibold))
                    }
                    .frame(width: 150, height: 200, alignment: .top)
                    VStack {
                        Picker("".localized, selection: oneTapNum) {
                            ForEach(1...200, id: \.self) { num in
                                Text(String(num))
                                    .bodyText()
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        Text("Number of Times per Set".localized)
                            .subColor()
                            .font(.system(size: FontSize.caption.rawValue, weight: .semibold))
                    }
                    .frame(width: 150, height: 200, alignment: .top)
                }
            }
            Divider()
            HStack {
                Text("Split into Sets".localized)
                    .bodyText()
                Spacer()
                FlToggle(isSet)
                    .accessibility(identifier: "isSetToggle")
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
