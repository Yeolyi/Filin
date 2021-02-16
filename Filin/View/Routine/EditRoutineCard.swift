//
//  EditRoutineCard.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/14.
//

import SwiftUI

struct EditRoutineCard: View {
    
    let targetRoutine: FlRoutine
    
    @StateObject var listData = FlListModel<FlHabit>(values: [], save: {_ in})
    @StateObject var routineCopy = FlRoutine(name: "")
    
    @State var index = 0
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var routineManager: RoutineManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    init(targetRoutine: FlRoutine, habits: [FlHabit]) {
        self.targetRoutine = targetRoutine
    }
    
    private enum RoutineSection: Int, CaseIterable {
        case name, dayOfWeek, list, reminder, others
        
        var description: String {
            switch self {
            case .name:
                return "Name".localized
            case .dayOfWeek:
                return "Repeat".localized
            case .list:
                return "List".localized
            case .reminder:
                return "Reminder".localized
            case .others:
                return "Others".localized
            }
        }
    }
    
    var isSaveAvailable: Bool {
        routineCopy.name != "" &&
            !routineCopy.repeatDay.isEmpty &&
            !filteredList.isEmpty
    }
    
    var filteredList: [FlHabit] {
        guard let index = listData.allValues.firstIndex(where: { $0.id == listData.dividerID }),
              index > 0 else {
            return []
        }
        return Array(listData.allValues[0..<index])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                IconButton(imageName: "xmark") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(format: NSLocalizedString("Edit %@", comment: ""), targetRoutine.name))
                    .bodyText()
                    .frame(maxWidth: .infinity, alignment: .center)
                TextButton(
                    content: { Text("Save".localized) },
                    isActive: isSaveAvailable
                ) {
                    routineCopy.list = filteredList
                    targetRoutine.applyChanges(copy: routineCopy, stateObjectException: true)
                    routineManager.objectWillChange.send()
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            FlTabView(index: $index, viewWidth: 350, viewNum: 5, lock: false) {
                Group {
                    HabitNameSection(name: $routineCopy.name, cardMode: .compact)
                    RepeatSection(cardMode: .compact, dayOfWeek: $routineCopy.repeatDay)
                    ListSection(listData: listData, dividerID: listData.dividerID, cardMode: .compact)
                    ReminderSection(timer: $routineCopy.time, cardMode: .compact)
                    OthersSection(targetRoutine: targetRoutine)
                }
                .frame(width: 330, height: 440)
                .rowBackground()
                .frame(width: 350)
            }
            .frame(width: 370)
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(RoutineSection.allCases, id: \.self) { section in
                        TextButtonWithoutGesture(content: {
                            Text(section.description)
                                .if(section.rawValue == index) {
                                    $0.foregroundColor(ThemeColor.brand)
                                }
                                .minimumScaleFactor(0.1)
                        }) {
                            UIApplication.shared.endEditing()
                            index = section.rawValue
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
            Spacer()
        }
        .if(colorScheme == .light) {
            $0.background(
                Rectangle()
                    .inactiveColor()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .onAppear {
            if routineCopy.name == "" {
                routineCopy.applyChanges(copy: targetRoutine, stateObjectException: true)
                var list = targetRoutine.list
                list.append(.init(id: listData.dividerID, name: "⬆️ Goals to be displayed ⬆️".localized, color: .gray))
                list.append(contentsOf: habitManager.contents.filter { !list.contains($0) })
                for habit in list {
                    listData.append(habit)
                }
            }
        }
    }
}

private struct OthersSection: View {
    
    let targetRoutine: FlRoutine
    @State var isDeleteAlert = false
    @EnvironmentObject var routineManager: RoutineManager
    @Environment(\.presentationMode) var presentationMode
    
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
    
    var deleteAlert: Alert {
        Alert(
            title: Text(String(format: NSLocalizedString("Are you sure you want to delete %@?", comment: ""),
                               targetRoutine.name)),
            message: nil,
            primaryButton: .default(Text("No, I'll leave it.".localized)),
            secondaryButton: .destructive(Text("Yes, I'll delete it.".localized), action: {
                routineManager.remove(withID: targetRoutine.id)
                presentationMode.wrappedValue.dismiss()
            }))
    }
    
}

struct EditRoutineCardView_Previews: PreviewProvider {
    static var previews: some View {
        let data = PreviewDataProvider.shared
        EditRoutineCard(
            targetRoutine: FlRoutine.sample(number: 0),
            habits: data.habitManager.contents
        )
        .environmentObject(data.routineManager)
        .environmentObject(AppSetting())
    }
}
