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
        VStack {
            ZStack {
                IconButton(imageName: "xmark") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text("Start Habit".localized)
                    .bodyText()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            FlTabView(index: $index, viewWidth: 350, viewNum: 5, lock: !isSaveAvailable) {
                Group {
                    HabitNameSection(name: $tempHabit.name, cardMode: .detail(pageIndicator: "1/5"))
                    ColorSection(color: $tempHabit.color, cardMode: .detail(pageIndicator: "2/5"))
                    RepeatSection(cardMode: .detail(pageIndicator: "3/5"), dayOfWeek: $tempHabit.dayOfWeek)
                    HabitCountSection(tempHabit: tempHabit, cardMode: .detail(pageIndicator: "4/5"))
                    HabitTimerSection(requiredSec: $tempHabit.requiredSec, cardMode: .detail(pageIndicator: "5/5"))
                }
                .frame(width: 330, height: 440)
                .rowBackground()
                .frame(width: 350)
            }
            .frame(width: 370)
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
                UIApplication.shared.endEditing()
                if index == 4 && isSaveAvailable {
                    habitManager.append(tempHabit, summaryManager: summaryManager)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    index += 1
                }
            }
            .padding(.bottom, 10)
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

struct AddHabitCard_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitCard()
            .environmentObject(AppSetting())
            .environmentObject(HabitManager())
            .environmentObject(SummaryManager())
        // RepeatSection(dayOfWeek: .constant([1, 2, 3]))
    }
}
