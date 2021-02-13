//
//  EditHabitCard.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/13.
//

import SwiftUI

struct EditHabitCard: View {
    
    let targetHabit: FlHabit
    
    @ObservedObject var tempHabit: FlHabit
    
    @State var index = 0
    @State var showTimes = false
    @State var isDeleteAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var appSetting: AppSetting
    
    enum HabitSection: Int, CaseIterable {
        case name, theme, dayOfWeek, count, timer
        
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
            }
        }
    }
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty && tempHabit.achievement.targetTimes > 0
    }
    
    init(targetHabit: FlHabit) {
        self.targetHabit = targetHabit
        tempHabit = targetHabit.copy
    }
    
    var body: some View {
        FlInlineNavigationBar(bar: {
            HStack {
                Text("\(tempHabit.name)")
                    .headline()
                Spacer()
                saveButton
            }
            .padding(.horizontal, 20)
        }) {
            VStack(spacing: 0) {
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
                                index = section.rawValue
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .padding(.top, 20)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var saveButton: some View {
        TextButton(content: { Text("Save".localized) }) {
            guard isSaveAvailable else { return }
            targetHabit.applyChanges(copy: tempHabit)
            habitManager.objectWillChange.send()
            self.presentationMode.wrappedValue.dismiss()
        }
        .opacity(isSaveAvailable ? 1.0 : 0.5)
    }
    
    var deleteButton: some View {
        TextButton(content: {
            Text("Delete".localized)
                .foregroundColor(.red)
        }, isActive: isSaveAvailable) {
            self.isDeleteAlert = true
        }
        .padding(.vertical, 30)
        .alert(isPresented: $isDeleteAlert) { deleteAlert }
    }
    
    var deleteAlert: Alert {
        Alert(
            title: Text(String(
                format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""),
                tempHabit.name
            )),
            message: nil,
            primaryButton: .default(Text("No, I'll leave it.".localized)),
            secondaryButton: .destructive(Text("Yes, I'll delete it.".localized), action: {
                for profile in summaryManager.contents {
                    if let index = profile.list.firstIndex(where: {$0 == tempHabit.id}) {
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
}

private struct NameSection: View {
    
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Name".localized)
                .smallSectionText()
            TextFieldWithEndButton(FlHabit.sample(number: 0).name, text: $name)
                .flatRowBackground()
            Spacer()
        }
        .offset(y: -20)
    }
}

private struct ColorSection: View {
    
    @Binding var color: Color
    
    var body: some View {
        VStack(spacing: 3) {
            Spacer()
            Text("Theme".localized)
                .smallSectionText()
            ColorHorizontalPicker(selectedColor: $color)
                .frame(maxWidth: .infinity)
                .flatRowBackground()
            Spacer()
        }
        .offset(y: -20)
    }
}

private struct RepeatSection: View {
    
    @Binding var dayOfWeek: Set<Int>
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
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
        }
    }
}

private struct CountSection: View {
    
    @ObservedObject var tempHabit: FlHabit
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Text("Number of Times".localized)
                    .bodyText()
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.leading, 20)
            HabitNumberSetting(tempHabit)
            Spacer()
        }
    }
}

private struct TimerSection: View {
    
    @Binding var requiredSec: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Text("Timer".localized)
                    .bodyText()
                Spacer()
            }
            .padding(.leading, 20)
            HabitTimerSetting(requiredSec: $requiredSec)
            Spacer()
        }
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
