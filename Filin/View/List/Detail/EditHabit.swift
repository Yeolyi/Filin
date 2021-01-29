//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI
import LocalAuthentication

struct EditHabit: View {
    
    let targetHabit: FlHabit
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @ObservedObject var tempHabit: FlHabit
    @State var showTimes = false
    @State var isDeleteAlert = false
    @State var _isRequiredTime = false
    var isRequiredTime: Binding<Bool> {
        Binding(get: {_isRequiredTime}, set: {
            _isRequiredTime = $0
            if $0 == false {
                tempHabit.requiredSec = 0
            }
        })
    }
    @State var _minute: Int
    var minute: Binding<Int> {
        Binding(get: {_minute},
                set: {
                    _minute = $0
                    tempHabit.requiredSec = $0 * 60 + _second
                })
    }
    @State var _second: Int
    var second: Binding<Int> {
        Binding(get: {_second},
                set: {
                    _second = $0
                    tempHabit.requiredSec = $0 + _minute * 60
                })
    }
    
    @State var _isSet = false
    var isSet: Binding<Bool> {
        Binding(get: { _isSet}, set: {
            _isSet = $0
            if $0 {
                tempHabit.achievement.addUnit = tempHabit.achievement.numberOfTimes
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
            tempHabit.achievement.numberOfTimes = $0 * tempHabit.achievement.addUnit
        })
    }
    
    var oneTapNum: Binding<Int> {
        Binding(get: {tempHabit.achievement.addUnit}, set: {
            tempHabit.achievement.addUnit = $0
            tempHabit.achievement.numberOfTimes = _setNum * $0
        })
    }
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty && tempHabit.achievement.numberOfTimes > 0
    }
    
    init(targetHabit: FlHabit) {
        self.targetHabit = targetHabit
        tempHabit = FlHabit(name: "Temp")
        __setNum = State(
            initialValue: targetHabit.achievement.addUnit != 1 ?
                targetHabit.achievement.numberOfTimes / targetHabit.achievement.addUnit : 1
        )
        __minute = State(initialValue: targetHabit.requiredSec/60)
        __second = State(initialValue: targetHabit.requiredSec%60)
        __isRequiredTime = State(initialValue: targetHabit.requiredSec != 0)
        __isSet = State(initialValue: targetHabit.achievement.addUnit != 1)
        tempHabit.update(to: targetHabit)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("\(tempHabit.name)")
                        .headline()
                    Spacer()
                    saveButton
                }
                .padding(20)
                Divider()
            }
            ScrollView {
                VStack(spacing: 8) {
                    HStack {
                        Text("Name".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    TextFieldWithEndButton("Drink water".localized, text: $tempHabit.name)
                        .rowBackground()
                    HStack {
                        Text("Times".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    VStack {
                        HStack {
                            Text("\(showTimes ? "Fold" : "Expand")".localized)
                                .subColor()
                                .bodyText()
                            Spacer()
                            BasicImage(imageName: showTimes ? "chevron.up" : "chevron.down")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showTimes.toggle()
                            }
                        }
                        if showTimes {
                            Group {
                                HStack {
                                    Text("Split into sets".localized)
                                        .bodyText()
                                    Spacer()
                                    PaperToggle(isSet)
                                }
                                if !isSet.wrappedValue {
                                    PickerWithButton(
                                        str: "".localized, size: 100, number: $tempHabit.achievement.numberOfTimes
                                    )
                                } else {
                                    PickerWithButton(
                                        str: "Number of times per set".localized, size: 100, number: oneTapNum
                                    )
                                    PickerWithButton(
                                        str: "Number of sets".localized, size: 30, number: setNum
                                    )
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                    .rowBackground()
                    HStack {
                        Text("Timer".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    VStack {
                        HStack {
                            Text("\(isRequiredTime.wrappedValue ? "On" : "Off")".localized)
                                .subColor()
                                .bodyText()
                            Spacer()
                            PaperToggle(isRequiredTime)
                        }
                        if isRequiredTime.wrappedValue {
                            TimerPicker(minute: minute, second: second)
                        }
                    }
                    .rowBackground()
                    Group {
                        HStack {
                            Text("Repeat".localized)
                                .bodyText()
                                .padding(.top, 10)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                            Spacer()
                        }
                        .rowBackground()
                    }
                    Group {
                        HStack {
                            Text("Color".localized)
                                .bodyText()
                                .padding(.top, 10)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            ColorHorizontalPicker(selectedColor: $tempHabit.color)
                            Spacer()
                        }
                        .rowBackground()
                        .padding(.bottom, 30)
                    }
                    Divider()
                    deleteButton
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    var saveButton: some View {
        HeaderText("Save".localized) {
            guard isSaveAvailable else { return }
            targetHabit.update(to: tempHabit)
            habitManager.objectWillChange.send()
            self.presentationMode.wrappedValue.dismiss()
        }
        .opacity(isSaveAvailable ? 1.0 : 0.5)
    }
    var deleteButton: some View {
        Button(action: { self.isDeleteAlert = true }) {
            Text("Delete".localized)
                .foregroundColor(.red)
                .bodyText()
                .padding(.vertical, 30)
        }
        .alert(isPresented: $isDeleteAlert) { deleteAlert }
    }
    var deleteAlert: Alert {
        Alert(
            title: Text(String(format: NSLocalizedString("Delete %@?", comment: ""), tempHabit.name)),
            message: nil,
            primaryButton: .default(Text("Cancel".localized)),
            secondaryButton: .destructive(Text("Delete".localized), action: {
                for profile in summaryManager.contents {
                    if let index = profile.habitArray.firstIndex(where: {$0 == tempHabit.id}) {
                        profile[index + 1] = nil
                    }
                }
                habitManager.remove(withID: targetHabit.id, summary: summaryManager.contents[0])
                self.presentationMode.wrappedValue.dismiss()
            })
        )
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit(targetHabit: FlHabit(name: "Asd"))
    }
}
