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
    
    var isSaveAvailable: Bool {
        tempHabit.name != "" && !tempHabit.dayOfWeek.isEmpty && tempHabit.achievement.numberOfTimes > 0
    }
    
    init(targetHabit: FlHabit) {
        self.targetHabit = targetHabit
        tempHabit = FlHabit(name: "Temp")
        tempHabit.update(to: targetHabit)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("\(tempHabit.name)")
                        .headline()
                    Spacer()
                    saveButton
                }
                .compositingGroup()
                .padding(20)
                .background(Color.white)
                Divider()
                Spacer()
            }
            .zIndex(1)
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 5) {
                        HStack {
                            Text("Name".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        TextFieldWithEndButton("Drink water".localized, text: $tempHabit.name)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text("Color".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        ColorHorizontalPicker(selectedColor: $tempHabit.color)
                            .frame(maxWidth: .infinity)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text("Day of the week".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        DayOfWeekSelector(dayOfTheWeek: $tempHabit.dayOfWeek)
                            .frame(maxWidth: .infinity)
                            .flatRowBackground()
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text("Number of times".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        HabitNumberSetting(tempHabit)
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text("Timer".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        HabitTimerSetting(requiredSec: $tempHabit.requiredSec)
                    }
                    Divider()
                    deleteButton
                }
            }
            .padding(.top, 90)
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
                    if let index = profile.list.firstIndex(where: {$0 == tempHabit.id}) {
                        profile.list.remove(at: index)
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
