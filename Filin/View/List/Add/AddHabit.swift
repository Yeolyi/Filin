//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AddHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tempHabit = FlHabit(name: "")
    
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.colorScheme) var colorScheme
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty
            && tempHabit.achievement.targetTimes != 0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 0) {
                    LottieView(filename: "lottiePlus")
                        .frame(width: 120, height: 120)
                        .if(colorScheme == .dark) {
                            $0.colorInvert()
                        }
                    Text(appSetting.isFirstRun && habitManager.contents.isEmpty ?
                            "Make first goal".localized : "Make new goal".localized)
                        .title()
                }
                .padding(.top, 21)
                .padding(.bottom, 35)
                VStack(spacing: 3) {
                    HStack {
                        Text("Tell me the name of the goal.".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    TextFieldWithEndButton([FlHabit.sample(number: 0), FlHabit.sample(number: 1)].randomElement()!.name, text: $tempHabit.name)
                        .flatRowBackground()
                        .accessibility(identifier: "habitName")
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Choose the day of the week to repeat your goal.".localized)
                            .bodyText()
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                        .frame(maxWidth: .infinity)
                        .flatRowBackground()
                        .accessibility(identifier: "dayOfWeek")
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("How many times a day will you do it?".localized)
                            .bodyText()
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    HabitNumberSetting(tempHabit)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Do you want me to prepare a timer when the goal starts?".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    HabitTimerSetting(requiredSec: $tempHabit.requiredSec)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Choose a color that matches your goal.".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    ColorHorizontalPicker(selectedColor: $tempHabit.color)
                        .frame(maxWidth: .infinity)
                        .flatRowBackground()
                }
                MainRectButton(action: saveAndQuit, str: "Create a new goal".localized)
                    .padding(.vertical, 30)
                    .opacity(isSaveAvailable ? 1 : 0.3)
                    .disabled(!isSaveAvailable)
                    .accessibility(identifier: "createGoal")
            }
            .padding(.top, 1)
        }
        .accessibility(identifier: "habitAddView")
    }
    
    func saveAndQuit() {
        habitManager.append(tempHabit, summaryManager: summaryManager)
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        return AddHabit()
            .environmentObject(AppSetting())
            .environmentObject(PreviewDataProvider.shared.habitManager)
    }
}
