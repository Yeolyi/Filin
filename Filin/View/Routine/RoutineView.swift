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
    
    var emptyIndicatingRow: some View {
        HStack {
            Spacer()
            Text("Empty".localized)
                .subColor()
            Spacer()
        }
        .flatRowBackground()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Today".localized)
                        .sectionText()
                    if !routineManager.contents.filter({
                        $0.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek)
                    }).isEmpty {
                        VStack(spacing: 0) {
                            ForEach(
                                routineManager.contents.filter {
                                    $0.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek)
                                }
                            ) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        emptyIndicatingRow
                    }
                    Text("Others".localized)
                        .sectionText()
                    if !routineManager.contents.filter({
                        !$0.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek)
                    }).isEmpty {
                        VStack(spacing: 0) {
                            ForEach(
                                routineManager.contents.filter {
                                    !$0.dayOfWeek.contains(appSetting.mainDate.dayOfTheWeek)
                                }
                            ) { routine in
                                RoutineRow(routine: routine, isSheet: $isAddSheet)
                            }
                        }
                    } else {
                        emptyIndicatingRow
                    }
                }
                .padding(.top, 1)
                .navigationBarTitle("Routine".localized)
                .navigationBarItems(
                    trailing: HeaderButton("plus") {
                        self.isAddSheet = .add
                    }
                )
                .sheet(item: $isAddSheet) { sheetType in
                    switch sheetType {
                    case RoutineSheet.add:
                        AddRoutine()
                            .environmentObject(habitManager)
                            .environmentObject(routineManager)
                    case RoutineSheet.edit(let routine):
                        EditRoutine(routine: routine)
                            .environmentObject(habitManager)
                            .environmentObject(routineManager)
                            .accentColor(ThemeColor.mainColor(colorScheme))
                    }
                }
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
