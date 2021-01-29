//
//  EditRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct EditRoutine: View {
    
    let targetRoutine: FlRoutine
    
    @ObservedObject var tempRoutine: FlRoutine
    @ObservedObject var listData: EditableList<UUID>
    
    @State var isReminderUsed: Bool
    @State var reminderTime: Date
    @State var isDeleteAlert = false
    
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var habitManager: HabitManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    init(routine: FlRoutine) {
        targetRoutine = routine
        tempRoutine = FlRoutine(copyExceptID: routine)
        if let time = routine.time {
            _isReminderUsed = State(initialValue: true)
            _reminderTime = State(initialValue: time)
        } else {
            _isReminderUsed = State(initialValue: true)
            _reminderTime = State(initialValue: Date())
        }
        listData = EditableList<UUID>(values: routine.list.map(\.id), save: {_ in})
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("\(tempRoutine.name)")
                            .headline()
                        Spacer()
                        HeaderText("Save".localized) {
                            tempRoutine.list = listData.allValues.compactMap { id in
                                habitManager.contents.first(where: {$0.id == id})
                            }
                            tempRoutine.time = isReminderUsed ? reminderTime : nil
                            targetRoutine.update(to: tempRoutine)
                            presentationMode.wrappedValue.dismiss()
                        }
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
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        TextFieldWithEndButton("Drink water".localized, text: $tempRoutine.name)
                            .rowBackground()
                        HStack {
                            Text("List".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        NavigationLink(destination:
                                        RoutineSetList(listData: listData)
                                        .navigationBarTitle(Text(""), displayMode: .inline)
                        ) {
                            HStack {
                                Text(
                                    String(
                                        format: NSLocalizedString("Consists of %d goals", comment: ""),
                                        tempRoutine.list.count
                                    )
                                )
                                    .bodyText()
                                Spacer()
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .mainColor()
                        }
                        .rowBackground()
                        HStack {
                            Text("Repeat")
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        HStack {
                            Spacer()
                            DayOfWeekSelector(dayOfTheWeek: $tempRoutine.dayOfWeek)
                            Spacer()
                        }
                        .rowBackground()
                        HStack {
                            Text("Reminder".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        VStack {
                            HStack {
                                Text("\(isReminderUsed ? "On" : "Off")".localized)
                                    .bodyText()
                                Spacer()
                                if isReminderUsed {
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .accentColor(ThemeColor.mainColor(colorScheme))
                                }
                                PaperToggle($isReminderUsed)
                            }
                        }
                        .rowBackground()
                        Divider()
                        Button(action: {self.isDeleteAlert = true}) {
                            Text("Delete".localized)
                                .foregroundColor(.red)
                                .bodyText()
                        }
                        .frame(minWidth: 44, minHeight: 22)
                        .alert(isPresented: $isDeleteAlert) { deleteAlert }
                        .padding(.vertical, 30)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    var deleteAlert: Alert {
        Alert(
            title: Text(String(format: NSLocalizedString("Delete %@?", comment: ""), tempRoutine.name)),
            message: nil,
            primaryButton: .default(Text("Cancel".localized)),
            secondaryButton: .destructive(Text("Delete".localized), action: {
                routineManager.remove(withID: targetRoutine.id)
                presentationMode.wrappedValue.dismiss()
            }))
    }
}

struct EditRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = DataSample.shared
        EditRoutine(routine: FlRoutine.routine1)
            .environmentObject(coreDataPreview.routineManager)
            .environmentObject(coreDataPreview.habitManager)
    }
}
