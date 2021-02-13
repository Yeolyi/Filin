//
//  AddHabitCard.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/13.
//

import SwiftUI

struct AddHabitCard: View {
    
    @State var index = 0
    @ObservedObject var tempHabit = FlHabit(name: "")
    
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var isSaveAvailable: Bool {
        switch index {
        case 0:
            return tempHabit.name != ""
        case 1, 3, 4:
            return true
        case 2:
            return !tempHabit.dayOfWeek.isEmpty
        default:
            assertionFailure()
            return true
        }
    }
    
    var buttonLabel: String {
        if index == 4 && isSaveAvailable {
            return "Create a New Goal".localized
        } else {
            return "To the Next Level".localized
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            IconButton(imageName: "xmark") {
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading], 20)
            Spacer()
            FlTabView(index: $index, viewWidth: 350, viewNum: 5, lock: !isSaveAvailable) {
                Group {
                    NameSection(name: $tempHabit.name)
                    ColorSection(color: $tempHabit.color)
                    RepeatSection(dayOfWeek: $tempHabit.dayOfWeek)
                    CountSection(tempHabit: tempHabit)
                    TimerSection(requiredSec: $tempHabit.requiredSec)
                }
                .frame(width: 330, height: 450)
                .rowBackground()
                .frame(width: 350)
            }
            .frame(width: 380)
            .padding(.bottom, 20)
            Spacer()
            TextButton(content: {
                Text("Previous".localized)
            }) {
                index = max(0, index - 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.bottom, 8)
            PrimaryButton(label: buttonLabel, isActive: isSaveAvailable) {
                if index == 4 && isSaveAvailable {
                    habitManager.append(tempHabit, summaryManager: summaryManager)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    index += 1
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
        }
        .if(colorScheme == .light) {
            $0.background(
                Rectangle()
                    .inactiveColor()
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

private struct NameSection: View {
    
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 3) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Getting Started\nwith a new Goal")
                    .foregroundColor(ThemeColor.brand)
                    .headline()
                    .lineSpacing(5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading], 10)
            Spacer()
            Text("Tell me the name of the goal.".localized)
                .smallSectionText()
            TextFieldWithEndButton(FlHabit.sample(number: 0).name, text: $name)
                .flatRowBackground()
            Spacer()
            Text("1/5")
                .bodyText()
        }
    }
}

private struct ColorSection: View {
    
    @Binding var color: Color
    
    var body: some View {
        VStack(spacing: 3) {
            Spacer()
            Text("Choose a color that matches your goal.".localized)
                .smallSectionText()
            ColorHorizontalPicker(selectedColor: $color)
                .frame(maxWidth: .infinity)
                .flatRowBackground()
            Spacer()
            Text("2/5")
                .bodyText()
        }
    }
}

private struct RepeatSection: View {
    
    @Binding var dayOfWeek: Set<Int>
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Choose the day of the week to repeat your goal.".localized)
                .bodyText()
                .lineLimit(nil)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 10) {
                ForEach(
                    appSetting.isMondayStart ? [2, 3, 4, 5, 6, 7, 1] : [1, 2, 3, 4, 5, 6, 7],
                    id: \.self
                ) { dayOfWeekInt in
                    TextButton(content: {
                        HStack {
                            Text(Date.dayOfTheWeekStr(dayOfWeekInt))
                            Spacer()
                            if dayOfWeek.contains(dayOfWeekInt) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }) {
                        if dayOfWeek.contains(dayOfWeekInt) {
                            dayOfWeek.remove(dayOfWeekInt)
                        } else {
                            dayOfWeek.insert(dayOfWeekInt)
                        }
                    }
                    Divider()
                }
            }
            Spacer()
            Text("3/5")
                .bodyText()
        }
    }
}

private struct CountSection: View {
    
    @ObservedObject var tempHabit: FlHabit
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Text("How many times a day will you do it?".localized)
                    .bodyText()
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.leading, 20)
            HabitNumberSetting(tempHabit)
            Spacer()
            Text("4/5")
                .bodyText()
        }
    }
}

private struct TimerSection: View {
    
    @Binding var requiredSec: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Text("Should I prepare a timer when you perform this goal?".localized)
                    .bodyText()
                Spacer()
            }
            .padding(.leading, 20)
            HabitTimerSetting(requiredSec: $requiredSec)
            Spacer()
            Text("5/5")
                .bodyText()
        }
    }
}

struct AddHabitCard_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitCard()
            .environmentObject(AppSetting())
            .environmentObject(HabitManager())
            .environmentObject(SummaryManager())
        // RepeatSection(dayOfWeek: .constant([1, 2, 3]))
    }
}
