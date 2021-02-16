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
            return !selectedList.isEmpty
        case 3:
            return newRoutine.name != "" && !newRoutine.repeatDay.isEmpty && !selectedList.isEmpty
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
    
    var selectedList: [FlHabit] {
        guard let index = listData.allValues.firstIndex(where: { $0.id == dividerID }), index > 0 else {
            return []
        }
        return Array(listData.allValues[0..<index])
    }
    
    func save() {
        guard isSaveAvailable else { return }
        guard let index = listData.allValues.firstIndex(where: { $0.id == dividerID }), index > 0 else {
            assertionFailure()
            return
        }
        newRoutine.list = selectedList
        routineManager.append(newRoutine)
        presentationMode.wrappedValue.dismiss()
        return
    }
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    IconButton(imageName: "xmark") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Add Routine".localized)
                        .bodyText()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                FlTabView(index: $index, viewWidth: 350, viewNum: 4, lock: !isSaveAvailable) {
                    Group {
                        NameSection(name: $newRoutine.name, cardMode: .detail(pageIndicator: "1/4"))
                        RepeatSection(cardMode: .detail(pageIndicator: "2/4"), dayOfWeek: $newRoutine.repeatDay)
                        ListSection(listData: listData, dividerID: dividerID, cardMode: .detail(pageIndicator: ""))
                        ReminderSection(timer: $newRoutine.time, cardMode: .detail(pageIndicator: "4/4"))
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
    let cardMode: CardMode
    
    var body: some View {
        VStack(spacing: 3) {
            if case .detail = cardMode {
                Text("Getting Started\nwith a new Routine".localized)
                    .foregroundColor(ThemeColor.brand)
                    .headline()
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 10)
            }
            Spacer()
            Group {
                if case .detail = cardMode {
                    Text("Tell me the name of the routine.".localized)
                } else {
                    Text("Name".localized)
                }
            }
            .smallSectionText()
            TextFieldWithEndButton(FlRoutine.sample(number: 0).name, text: $name)
                .flatRowBackground()
            Spacer()
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
        }
    }
}

struct ListSection: View {
    
    @ObservedObject var listData: FlListModel<FlHabit>
    
    let dividerID: UUID
    let cardMode: CardMode
    
    init(listData: FlListModel<FlHabit>, dividerID: UUID, cardMode: CardMode) {
        self.listData = listData
        self.dividerID = dividerID
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if case .detail = cardMode {
                Text("Choose your goals.".localized)
                    .bodyText()
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
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

struct ReminderSection: View {
    
    let cardMode: CardMode
    @Binding var timer: Date?
    
    var useReminder: Binding<Bool> {
        Binding(
            get: { timer != nil },
            set: {
                if $0 {
                    timer = Date()
                } else {
                    timer = nil
                }
            }
        )
    }
    
    var isAM: Binding<Bool> {
        Binding(
            get: {
                (timer ?? Date()).dateToTimer().isAM
            },
            set: {
                timer = Date(hour: hour.wrappedValue, minute: minute.wrappedValue, isAM: $0)
            }
        )
    }
    
    var hour: Binding<Int> {
        Binding(
            get: { (timer ?? Date()).dateToTimer().hour  },
            set: {
                timer = Date(hour: $0, minute: minute.wrappedValue, isAM: isAM.wrappedValue)
            }
        )
    }
    
    var minute: Binding<Int> {
        Binding(
            get: { (timer ?? Date()).dateToTimer().minute },
            set: {
                timer = Date(hour: hour.wrappedValue, minute: $0, isAM: isAM.wrappedValue)
            }
        )
    }
    
    init(timer: Binding<Date?>, cardMode: CardMode) {
        self._timer = timer
        self.cardMode = cardMode
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if case .detail = cardMode {
                HStack {
                    Text("Do you want me to tell you the time to start the routine?".localized)
                        .bodyText()
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.leading, 20)
            }
            VStack(spacing: 4) {
                HStack {
                    Text(useReminder.wrappedValue ? "On".localized : "Off".localized)
                        .bodyText()
                    Spacer()
                    FlToggle(useReminder)
                }
                .flatRowBackground()
                if useReminder.wrappedValue {
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
            if case .detail(let pageIndicator) = cardMode {
                Text(pageIndicator)
                    .bodyText()
            }
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
