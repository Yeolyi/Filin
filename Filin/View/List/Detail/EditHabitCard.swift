//
//  EditHabitCard.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/13.
//

import SwiftUI

struct EditHabitCard: View {
    
    let targetHabit: FlHabit
    
    @StateObject var tempHabit: FlHabit = FlHabit(name: "")
    
    @State var index = 0
    @State var showTimes = false
    @State var isDeleteAlert = false
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var appSetting: AppSetting
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    enum HabitSection: Int, CaseIterable {
        case name, theme, dayOfWeek, count, timer, others
        
        var string: String {
            switch self {
            case.name:
                return "Name".localized
            case .theme:
                return "Theme".localized
            case .dayOfWeek:
                return "Repeat".localized
            case .count:
                return "Number of Times".localized
            case .timer:
                return "Timer".localized
            case .others:
                return "Others".localized
            }
        }
    }
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty && tempHabit.achievement.targetTimes > 0
    }
    
    init(targetHabit: FlHabit) {
        self.targetHabit = targetHabit
    }
    
    var body: some View {
        VStack {
            ZStack {
                IconButton(imageName: "xmark") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(format: NSLocalizedString("Edit %@", comment: ""), targetHabit.name))
                    .bodyText()
                TextButton(
                content: { Text("Save".localized) },
                isActive: isSaveAvailable
                ) {
                    guard isSaveAvailable else { return }
                    targetHabit.applyChanges(copy: tempHabit, stateObjectException: true)
                    habitManager.objectWillChange.send()
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            FlTabView(index: $index, viewWidth: 350, viewNum: 6, lock: !isSaveAvailable) {
                Group {
                    HabitNameSection(name: $tempHabit.name, cardMode: .compact)
                    ColorSection(color: $tempHabit.color, cardMode: .compact)
                    RepeatSection(cardMode: .compact, dayOfWeek: $tempHabit.dayOfWeek)
                    HabitCountSection(tempHabit: tempHabit, cardMode: .compact)
                    HabitTimerSection(requiredSec: $tempHabit.requiredSec, cardMode: .compact).equatable()
                    OthersSection(targetHabit: targetHabit)
                }
                .frame(width: 330, height: 440)
                .rowBackground()
                .frame(width: 350)
            }
            .frame(width: 370)
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(HabitSection.allCases, id: \.self) { section in
                        TextButtonWithoutGesture(content: {
                            Text(section.string)
                                .if(section.rawValue == index) {
                                    $0.foregroundColor(ThemeColor.brand)
                                }
                        }) {
                            UIApplication.shared.endEditing()
                            index = section.rawValue
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .if(colorScheme == .light) {
            $0.background(
                Rectangle()
                    .inactiveColor()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .onAppear {
            if tempHabit.name == "" {
                tempHabit.applyChanges(copy: targetHabit, stateObjectException: true)
            }
        }
    }
}

private struct OthersSection: View {
    
    @State var isDeleteAlert = false
    let targetHabit: FlHabit
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var deleteAlert: Alert {
        Alert(
            title: Text(String(
                format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""),
                targetHabit.name
            )),
            message: nil,
            primaryButton: .default(Text("No, I'll leave it.".localized)),
            secondaryButton: .destructive(Text("Yes, I'll delete it.".localized), action: {
                for profile in summaryManager.contents {
                    if let index = profile.list.firstIndex(where: {$0 == targetHabit.id}) {
                        profile.list.remove(at: index)
                    }
                }
                habitManager.remove(
                    withID: targetHabit.id, summary: summaryManager.contents[0], routines: routineManager.contents
                )
                self.presentationMode.wrappedValue.dismiss()
            })
        )
    }
    
    var body: some View {
        TextButton(content: {
            Text("Delete".localized)
                .foregroundColor(.red)
        }) {
            self.isDeleteAlert = true
        }
        .padding(.vertical, 30)
        .alert(isPresented: $isDeleteAlert) { deleteAlert }
    }
}

struct EditHabitCard_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitCard(targetHabit: FlHabit.sample(number: 0))
            .environmentObject(PreviewDataProvider.shared.habitManager)
            .environmentObject(PreviewDataProvider.shared.routineManager)
            .environmentObject(PreviewDataProvider.shared.summaryManager)
            .environmentObject(AppSetting())
    }
}
