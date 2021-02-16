//
//  HabitNumberSetting.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/02.
//

import SwiftUI

struct HabitNumberSetting: View {
    
    @ObservedObject var tempHabit: FlHabit
    /*
     if value {
     tempHabit.achievement.addUnit = oneTapNum
     tempHabit.achievement.targetTimes = oneTapNum * setNum
     } else {
     tempHabit.achievement.addUnit = 1
     tempHabit.achievement.targetTimes = oneTapNum
     }
     */
    
    var isSet: Binding<Bool> {
        Binding(
            get: {
                tempHabit.achievement.isSet
            }, set: {
                if $0 {
                    tempHabit.achievement.addUnit = setNum.wrappedValue == 1 ? 2 : setNum.wrappedValue
                    tempHabit.achievement.targetTimes = oneTapNum.wrappedValue * setNum.wrappedValue
                } else {
                    tempHabit.achievement.addUnit = 1
                    tempHabit.achievement.targetTimes = oneTapNum.wrappedValue
                }
            }
        )
    }
    var setNum: Binding<Int> {
        Binding(
            get: {
                tempHabit.achievement.addUnit
            }, set: {
                let backup = oneTapNum.wrappedValue
                tempHabit.achievement.addUnit = $0
                tempHabit.achievement.targetTimes = $0 * backup
            }
        )
    }
    
    var oneTapNum: Binding<Int> {
        Binding(
            get: {
                tempHabit.achievement.targetTimes / tempHabit.achievement.addUnit
            }, set: {
                tempHabit.achievement.targetTimes = $0 * self.setNum.wrappedValue
            })
    }
    
    init(_ tempHabit: FlHabit) {
        self.tempHabit = tempHabit
    }
    
    var body: some View {
        VStack(spacing: 15) {
            if !isSet.wrappedValue {
                Picker("", selection: oneTapNum) {
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
                        Picker("", selection: oneTapNum) {
                            ForEach(1...30, id: \.self) { num in
                                Text(String(num))
                                    .bodyText()
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        
                        Text("Number of Sets".localized)
                            .subColor()
                            .font(.system(size: FontSize.caption.rawValue, weight: .semibold))
                    }
                    .frame(width: 150, height: 200, alignment: .top)
                    VStack {
                        Picker("".localized, selection: setNum) {
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
