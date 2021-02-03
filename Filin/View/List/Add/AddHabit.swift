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
        #if DEBUG
        return true
        #else
        return tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty
            && tempHabit.achievement.numberOfTimes != 0
        #endif
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
                        Text("What is the name of the goal?".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    TextFieldWithEndButton("Drink water".localized, text: $tempHabit.name)
                        .flatRowBackground()
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Choose the day of the week to proceed with the goal.".localized)
                            .bodyText()
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                        .frame(maxWidth: .infinity)
                        .flatRowBackground()
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("How many times do you want to achieve your goal in a day?".localized)
                            .bodyText()
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    HabitNumberSetting(tempHabit)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("""
                            Use a timer if you need a specific time to \
                            achieve your goal.\nE.g. two-minute plank.
                            """.localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    HabitTimerSetting(requiredSec: $tempHabit.requiredSec)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Select theme color.".localized)
                            .bodyText()
                        Spacer()
                    }
                    .padding(.leading, 20)
                    ColorHorizontalPicker(selectedColor: $tempHabit.color)
                        .frame(maxWidth: .infinity)
                        .flatRowBackground()
                }
                MainRectButton(action: saveAndQuit, str: "Done".localized)
                    .padding(.vertical, 30)
                    .opacity(isSaveAvailable ? 1 : 0.3)
                    .disabled(!isSaveAvailable)
            }
            .padding(.top, 1)
        }
    }
    
    func saveAndQuit() {
        HabitManager.shared.append(tempHabit, summaryManager: summaryManager)
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        return AddHabit()
            .environmentObject(AppSetting())
            .environmentObject(DataSample.shared.habitManager)
    }
}
