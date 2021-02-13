//
//  AddRoutineCard.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/13.
//

import SwiftUI

struct AddRoutineCard: View {
    
    let dividerID: UUID
    
    @ObservedObject var newRoutine = FlRoutine(name: "")
    @ObservedObject var listData: FlListModel<FlHabit>
    
    @State var index = 0
    @State var list: [FlHabit] = []
    
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    init(habits: [FlHabit]) {
        let dividerID = UUID()
        self.dividerID = dividerID
        var list = habits
        list.insert(.init(id: dividerID, name: "⬆️ Goals to be displayed ⬆️".localized, color: .gray), at: 0)
        listData = .init(values: list, save: { _ in })
    }
    
    var isSaveAvailable: Bool {
        switch index {
        case 0:
            return newRoutine.name != ""
        case 1:
            return !newRoutine.repeatDay.isEmpty
        case 2:
            return !listData.allValues.isEmpty
        case 3:
            return newRoutine.name != "" && !newRoutine.repeatDay.isEmpty && !listData.allValues.isEmpty
        default:
            assertionFailure()
            return true
        }
    }
    
    var buttonLabel: String {
        if index == 3 && isSaveAvailable {
            return "Create a New Routine".localized
        } else {
            return "To the Next Level".localized
        }
    }
    
    func save() {
        guard isSaveAvailable else { return }
        guard let index = listData.allValues.firstIndex(where: { $0.id == dividerID }), index != 0 else {
            assertionFailure()
            return
        }
        newRoutine.list = Array(listData.allValues[0..<index])
        routineManager.append(newRoutine)
         presentationMode.wrappedValue.dismiss()
        return
    }
    
    var body: some View {
        VStack(spacing: 0) {
            IconButton(imageName: "xmark") {
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading], 20)
            Spacer()
            FlTabView(index: $index, viewWidth: 350, viewNum: 4, lock: !isSaveAvailable) {
                Group {
                    NameSection(name: $newRoutine.name)
                    RepeatSection(dayOfWeek: $newRoutine.repeatDay)
                    ListSection(listData: listData, dividerID: dividerID)
                    TimerSection(timer: $newRoutine.time)
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
                if index == 3 && isSaveAvailable {
                    save()
                    return
                }
                index = min(3, index + 1)
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
                Text("Getting Started\nwith a new Routine".localized)
                    .foregroundColor(ThemeColor.brand)
                    .headline()
                    .lineSpacing(5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading], 10)
            Spacer()
            Text("Tell me the name of the routine.".localized)
                .smallSectionText()
            TextFieldWithEndButton(FlRoutine.sample(number: 0).name, text: $name)
                .flatRowBackground()
            Spacer()
            Text("1/4")
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
            Text("Choose the day of the week to repeat your routine.".localized)
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
            Text("2/4")
                .bodyText()
        }
    }
}

private struct ListSection: View {
    
    @ObservedObject var listData: FlListModel<FlHabit>
    
    let dividerID: UUID
    
    init(listData: FlListModel<FlHabit>, dividerID: UUID) {
        self.listData = listData
        self.dividerID = dividerID
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Choose your goals.".localized)
                .bodyText()
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
            FlList(listData: listData) { id in
                HStack(spacing: 0) {
                    if listData.value(of: id).id != dividerID {
                        IconButtonWithoutGesture(imageName: "plus.rectangle.on.rectangle") {
                            listData.append(listData.value(of: id))
                        }
                    }
                    Text(listData.value(of: id).name)
                        .foregroundColor(listData.value(of: id).color)
                        .font(.custom("GodoB", size: 16))
                }
            }
        }
    }
}

private struct TimerSection: View {
    
    @State var _useReminder = false
    @State var _isAM: Bool = true
    @State var _hour: Int = 10
    @State var _minute: Int = 0
    
    @Binding var timer: Date?
    
    var useReminder: Binding<Bool> {
        Binding(
            get: { _useReminder },
            set: {
                _useReminder = $0
                if !$0 { timer = nil } else {
                    timer = Date(hour: _hour, minute: _minute, isAM: _isAM)
                }
            }
        )
    }
    
    var isAM: Binding<Bool> {
        Binding(
            get: { _isAM },
            set: {
                _isAM = $0
                timer = Date(hour: _hour, minute: _minute, isAM: $0)
            }
        )
    }
    
    var hour: Binding<Int> {
        Binding(
            get: { _hour },
            set: {
                _hour = $0
                timer = Date(hour: $0, minute: _minute, isAM: _isAM)
            }
        )
    }
    
    var minute: Binding<Int> {
        Binding(
            get: { _minute },
            set: {
                _minute = $0
                timer = Date(hour: _hour, minute: $0, isAM: _isAM)
            }
        )
    }
    
    init(timer: Binding<Date?>) {
        self._timer = timer
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Text("Reminder".localized)
                    .bodyText()
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.leading, 20)
            VStack(spacing: 4) {
                HStack {
                    Text(_useReminder ? "On".localized : "Off".localized)
                        .bodyText()
                    Spacer()
                    FlToggle(useReminder)
                }
                .flatRowBackground()
                if _useReminder {
                    HStack {
                        Picker(selection: hour, label: EmptyView(), content: {
                            ForEach(1...12, id: \.self) { hour in
                                Text(String(hour))
                                    .bodyText()
                            }
                        })
                        .frame(width: 100, height: 150)
                        .clipped()
                        Picker(selection: minute, label: EmptyView(), content: {
                            ForEach(0...59, id: \.self) { minute in
                                Text(String(minute))
                                    .bodyText()
                            }
                        })
                        .frame(width: 100, height: 150)
                        .clipped()
                        Picker(selection: isAM, label: EmptyView(), content: {
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
            Spacer()
            Text("4/4")
                .bodyText()
        }
    }
}

struct AddRoutineCard_Previews: PreviewProvider {
    static var previews: some View {
        let dataProvider = PreviewDataProvider.shared
        AddRoutineCard(habits: dataProvider.habitManager.contents)
            .environmentObject(dataProvider.habitManager)
            .environmentObject(dataProvider.routineManager)
            .environmentObject(AppSetting())
    }
}
