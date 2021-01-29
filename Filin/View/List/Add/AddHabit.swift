//
//  AddHabit.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/13.
//

import SwiftUI

struct AddHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var currentPage = 1
    let totalPage = 5
    @ObservedObject var tempHabit = FlHabit(name: "")
    var isNextAvailable: Bool {
        switch currentPage {
        case 1:
            return tempHabit.name != ""
        case 2: return !tempHabit.dayOfWeek.isEmpty
        case 3: return tempHabit.achievement.numberOfTimes > 0
        case 4: return !tempHabit.isTimer || tempHabit.requiredSec > 0
        case 5: return true
        default:
            assertionFailure()
            return true
        }
    }
    
    var body: some View {
        ZStack {
            if currentPage == 1 {
                NameSection(name: $tempHabit.name)
            }
            if currentPage == 2 {
                DateSection(dayOfTheWeek: $tempHabit.dayOfWeek)
            }
            if currentPage == 3 {
                TimesSection(
                    numberOfTimes: $tempHabit.achievement.numberOfTimes,
                    addUnit: $tempHabit.achievement.addUnit
                )
            }
            if currentPage == 4 {
                TimerSection(time: $tempHabit.requiredSec)
            }
            if currentPage == 5 {
                ThemeSection(color: $tempHabit.color)
            }
            VStack {
                Spacer()
                HStack {
                    previousButton
                    Spacer()
                }
                nextButton
            }
        }
        .padding(.bottom, 20)
    }
    var previousButton: some View {
        BasicTextButton("Previous".localized) {
            self.currentPage = max(self.currentPage - 1, 1)
        }
        .padding(.leading, 20)
        .padding(.bottom, 5)
        .if(currentPage == 1) {
            $0.hidden()
        }
    }
    var nextButton: some View {
        MainRectButton(
            action: {
                if isNextAvailable == false { return }
                if currentPage == totalPage {
                    saveAndQuit()
                    return
                }
                self.currentPage += 1
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            },
            str: currentPage == totalPage ? "Done".localized: "\("Next".localized) (\(currentPage)/\(totalPage))"
        )
        .opacity(isNextAvailable ? 1.0 : 0.5)
    }
    func saveAndQuit() {
        HabitManager.shared.append(tempHabit)
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        return AddHabit()
            .environmentObject(AppSetting())
    }
}
