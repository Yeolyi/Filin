//
//  AddRoutine.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

/// 새로운 루틴을 추가하는 뷰
struct AddRoutine: View {
    
    @State var isReminder = true
    
    @State var hour = 10
    @State var minute = 0
    @State var isAM = true
    @State var useReminder = true
    
    let dividerID: UUID
    
    @ObservedObject var newRoutine = FlRoutine(name: "")
    @ObservedObject var listData: FlListModel<FlHabit>
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var habitManager: HabitManager
    @Environment(\.colorScheme) var colorScheme
    
    var isSaveAvailable: Bool {
        (newRoutine.name != "" && !newRoutine.repeatDay.isEmpty && !dataFiltered.isEmpty)
    }
    
    init(habits: [FlHabit]) {
        dividerID = UUID()
        var list = habits
        list.insert(.init(id: dividerID, name: "⬆️ Goals to be displayed ⬆️".localized, color: .gray), at: 0)
        listData = .init(values: list) { _ in }
    }
    
    var dataFiltered: [FlHabit] {
        guard let dividerIndex = listData.allValues.firstIndex(where: {$0.id == dividerID}), dividerIndex != 0 else {
            return []
        }
        return Array(
            listData.list[0..<dividerIndex].map(\.value)
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 0) {
                        LottieView(filename: "lottieStack")
                            .frame(width: 120, height: 120)
                            .if(colorScheme == .dark) {
                                $0.colorInvert()
                            }
                        Text("Add Routine".localized)
                            .title()
                    }
                    .padding(.top, 21)
                    .padding(.bottom, 35)
                    VStack(spacing: 3) {
                        HStack {
                            Text("What is the name of the routine?".localized)
                                .bodyText()
                            Spacer()
                        }
                        .padding(.leading, 20)
                        TextFieldWithEndButton(
                            [FlRoutine.sample(number: 0), FlRoutine.sample(number: 1)].randomElement()!.name,
                            text: $newRoutine.name
                        )
                            .flatRowBackground()
                    }
                    VStack(spacing: 8) {
                        HStack {
                            Text("Select the day of the week to repeat the routine.".localized)
                                .bodyText()
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.leading, 20)
                        DayOfWeekSelector(dayOfTheWeek: $newRoutine.repeatDay)
                            .frame(maxWidth: .infinity)
                            .flatRowBackground()
                    }
                    VStack(spacing: 8) {
                        HStack {
                            Text("Choose your goals.".localized)
                                .bodyText()
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.leading, 20)
                        NavigationLink(destination:
                                        SelectRoutineList(cursorID: dividerID)
                            .environmentObject(listData)
                        ) {
                            HStack {
                                Text(String(format: NSLocalizedString("%d Goals Selected", comment: ""), dataFiltered.count))
                                    .bodyText()
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .subColor()
                            }
                            .flatRowBackground()
                        }
                    }
                    VStack(spacing: 8) {
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
                    MainRectButton(action: save, str: "Create a New Routine".localized)
                        .padding(.vertical, 30)
                        .opacity(isSaveAvailable ? 1 : 0.3)
                        .disabled(!isSaveAvailable)
                }
            }
            .padding(.top, 1)
            .navigationBarHidden(true)
        }
    }
    
    func save() {
        guard isSaveAvailable else { return }
        if isReminder {
            var components = DateComponents()
            components.hour = isAM ? hour : hour + 12
            components.minute = minute
            let date = Calendar.current.date(from: components)
            newRoutine.time = date
        }
        newRoutine.list = dataFiltered
        routineManager.append(newRoutine)
        presentationMode.wrappedValue.dismiss()
        return
    }
    
}

struct AddRoutine_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = PreviewDataProvider.shared
        return Group {
            AddRoutine(habits: dataSample.habitManager.contents)
        }
    }
}
