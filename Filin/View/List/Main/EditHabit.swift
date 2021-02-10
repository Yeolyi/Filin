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
    @ObservedObject var tempHabit: FlHabit
    @State var showTimes = false
    @State var isDeleteAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    
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
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 5) {
                        Text("Name".localized)
                            .smallSectionText()
                        TextFieldWithEndButton("Drink water".localized, text: $tempHabit.name)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        Text("Theme".localized)
                            .smallSectionText()
                        ColorHorizontalPicker(selectedColor: $tempHabit.color)
                            .frame(maxWidth: .infinity)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        Text("Repeat".localized)
                            .smallSectionText()
                        DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                            .frame(maxWidth: .infinity)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        Text("Number of times".localized)
                            .smallSectionText()
                        HabitNumberSetting(tempHabit)
                    }
                    VStack(spacing: 5) {
                        Text("Timer".localized)
                            .smallSectionText()
                        HabitTimerSetting(requiredSec: $tempHabit.requiredSec)
                    }
                    Divider()
                    deleteButton
                }
                .padding(.top, 10)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    var saveButton: some View {
        HeaderText("Save".localized) {
            guard isSaveAvailable else { return }
            targetHabit.applyChanges(copy: tempHabit)
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
            title: Text(String(format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""), tempHabit.name)),
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

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit(targetHabit: FlHabit(name: "Asd"))
            .environment(\.colorScheme, .light)
    }
}
