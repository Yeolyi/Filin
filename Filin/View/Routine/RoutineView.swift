//
//  RoutineMainView.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/25.
//

import SwiftUI

enum RoutineSheet: Identifiable {
    case add
    case edit(FlRoutine)
    var id: Int {
        switch self {
        case .add:
            return 0
        case .edit:
            return 1
        }
    }
}

struct RoutineView: View {
    
    @State var isAddSheet: RoutineSheet?
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var routineManager: RoutineManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Today".localized)
                        .sectionText()
                    if !routineManager.todoRoutines(at: appSetting.mainDate.dayOfTheWeek).isEmpty {
                        VStack(spacing: 0) {
                            ForEach(routineManager.todoRoutines(at: appSetting.mainDate.dayOfTheWeek)) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        SubIndicatingRow(label: "There is no planned routine today.".localized)
                    }
                    Text("Others".localized)
                        .sectionText()
                    if !routineManager.otherRoutines(at: appSetting.mainDate.dayOfTheWeek).isEmpty {
                        VStack(spacing: 0) {
                            ForEach(routineManager.otherRoutines(at: appSetting.mainDate.dayOfTheWeek)) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        SubIndicatingRow(label: "There is no routine on other days.".localized)
                    }
                }
                .navigationBarTitle("Routine".localized)
                .navigationBarItems(
                    trailing: IconButton(imageName: "plus") {
                        self.isAddSheet = .add
                    }
                )
                .fullScreenCover(item: $isAddSheet) { sheetType in
                    switch sheetType {
                    case RoutineSheet.add:
                        AddRoutineCard(habits: habitManager.contents)
                            .environmentObject(habitManager)
                            .environmentObject(routineManager)
                            .environmentObject(appSetting)
                    case RoutineSheet.edit(let routine):
                        EditRoutineCard(targetRoutine: routine, habits: habitManager.contents)
                            .environmentObject(habitManager)
                            .environmentObject(routineManager)
                            .environmentObject(appSetting)
                    }
                }
            }
            .padding(.top, 1)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = PreviewDataProvider.shared
        RoutineView()
            .environmentObject(dataSample.habitManager)
            .environmentObject(dataSample.summaryManager)
            .environmentObject(dataSample.routineManager)
            .environmentObject(AppSetting())
    }
}
