//
//  EditRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/26.
//

import SwiftUI

struct EditRoutine: View {
    
    let targetRoutine: FlRoutine
    let dividerID: UUID
    
    @ObservedObject var tempRoutine: FlRoutine
    @ObservedObject var listData: FlListModel<FlHabit>
    
    @State var useReminder: Bool
    @State var hour: Int
    @State var minute: Int
    @State var isAM: Bool
    
    @State var isDeleteAlert = false
    
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var habitManager: HabitManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    init(routine: FlRoutine, habits: [FlHabit]) {
        targetRoutine = routine
        tempRoutine = routine.copy
        if let time = routine.time {
            _useReminder = State(initialValue: true)
            let converted = time.dateToTimer()
            _hour = State(initialValue: converted.hour)
            _minute = State(initialValue: converted.minute)
            _isAM = State(initialValue: converted.isAM)
        } else {
            _useReminder = State(initialValue: false)
            _hour = State(initialValue: 10)
            _minute = State(initialValue: 0)
            _isAM = State(initialValue: true)
        }
        dividerID = UUID()
        var tempListData = routine.list
        tempListData.append(.init(id: dividerID, name: "⬆️ Goals to be displayed ⬆️".localized, color: .gray))
        tempListData.append(contentsOf: habits.filter {
            !(tempListData.contains($0))
        })
        listData = .init(values: tempListData, save: {_ in})
    }
    
    var filteredList: [FlHabit] {
        guard let index = listData.allValues.firstIndex(where: { $0.id == dividerID }),
              index != 0 else {
            return []
        }
        return Array(listData.allValues[0..<index])
    }
    
    var body: some View {
        NavigationView {
            FlInlineNavigationBar(bar: {
                HStack {
                    Text("\(tempRoutine.name)")
                        .headline()
                    Spacer()
                    HeaderText("Save".localized) {
                        tempRoutine.list = filteredList
                        if useReminder {
                            tempRoutine.time = Date(hour: hour, minute: minute, isAM: isAM)
                        } else {
                            tempRoutine.time = nil
                        }
                        targetRoutine.applyChanges(copy: tempRoutine)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.horizontal, 20)
            }) {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 5) {
                            HStack {
                                Text("Name".localized)
                                    .bodyText()
                                Spacer()
                            }
                            .padding(.leading, 20)
                            TextFieldWithEndButton(FlRoutine.sample(number: 0).name, text: $tempRoutine.name)
                                .flatRowBackground()
                        }
                        .padding(.top, 10)
                        VStack(spacing: 5) {
                            HStack {
                                Text("List".localized)
                                    .bodyText()
                                Spacer()
                            }
                            .padding(.leading, 20)
                            NavigationLink(destination:
                                            SelectRoutineList(cursorID: dividerID)
                                    .environmentObject(listData)
                            ) {
                                HStack {
                                    Text(String(
                                            format: NSLocalizedString("%d Goals Selected", comment: ""),
                                            filteredList.count
                                    ))
                                        .bodyText()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .mainColor()
                                }
                            }
                            .flatRowBackground()
                        }
                        VStack(spacing: 5) {
                            HStack {
                                Text("Repeat")
                                    .bodyText()
                                Spacer()
                            }
                            .padding(.leading, 20)
                            DayOfWeekSelector(dayOfTheWeek: $tempRoutine.repeatDay)
                                .frame(maxWidth: .infinity)
                            .flatRowBackground()
                        }
                        VStack(spacing: 5) {
                            HStack {
                                Text("Reminder".localized)
                                    .bodyText()
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding(.leading, 20)
                            VStack(spacing: 4) {
                                HStack {
                                    Text(useReminder ? "On".localized : "Off".localized)
                                        .bodyText()
                                    Spacer()
                                    PaperToggle($useReminder)
                                }
                                .flatRowBackground()
                                if useReminder {
                                    HStack {
                                        Picker(selection: $hour, label: EmptyView(), content: {
                                            ForEach(1...12, id: \.self) { hour in
                                                Text(String(hour))
                                                    .bodyText()
                                            }
                                        })
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                        Picker(selection: $minute, label: EmptyView(), content: {
                                            ForEach(0...59, id: \.self) { minute in
                                                Text(String(minute))
                                                    .bodyText()
                                            }
                                        })
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                        Picker(selection: $isAM, label: EmptyView(), content: {
                                            ForEach([true, false], id: \.self) { isAM in
                                                Text(isAM ? "AM" : "PM")
                                                    .bodyText()
                                            }
                                        })
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .flatRowBackground()
                                }
                            }
                        }
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
            title: Text(String(format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""), tempRoutine.name)),
            message: nil,
            primaryButton: .default(Text("No, I'll leave it.".localized)),
            secondaryButton: .destructive(Text("Yes, I'll delete it.".localized), action: {
                routineManager.remove(withID: targetRoutine.id)
                presentationMode.wrappedValue.dismiss()
            }))
    }
}

struct EditRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataPreview = PreviewDataProvider.shared
        EditRoutine(routine: FlRoutine.sample(number: 0), habits: coreDataPreview.habitManager.contents)
            .environmentObject(coreDataPreview.routineManager)
            .environmentObject(coreDataPreview.habitManager)
    }
}

extension Date {
    init(hour: Int, minute: Int, isAM: Bool) {
        var components = DateComponents()
        let hour24: Int
        if isAM {
            hour24 = hour == 12 ? 0 : hour
        } else {
            hour24 = hour == 12 ? hour : hour + 12
        }
        components.hour = hour24
        components.minute = minute
        self = Calendar.current.date(from: components)!
    }
    func dateToTimer() -> (hour: Int, minute: Int, isAM: Bool) {
        let isAM = self.hour < 12
        let hour: Int
        if isAM {
            hour = self.hour == 0 ? 12 : self.hour
        } else {
            hour = self.hour - 12 == 0 ? 12 : self.hour - 12
        }
        return (hour, self.minute, isAM)
    }
}
