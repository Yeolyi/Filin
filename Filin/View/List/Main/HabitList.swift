//
//  ContentView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

struct HabitList: View {
    
    @State var isSheet = false
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var summaryManager: SummaryManager
    @Environment(\.colorScheme) var colorScheme
    @State var timerReopen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination:
                        HabitTimer(
                            date: appSetting.mainDate,
                            habit: TimerManager.habit(habitManager) ?? FlHabit(name: "A")
                        ),
                    isActive: $timerReopen
                ) {
                    EmptyView()
                }
                .hidden()
                .zIndex(0)
                HabitScrollView()
                .zIndex(1)
            }
            .navigationBarTitle(appSetting.mainDate.localizedMonthDay)
            .navigationBarItems(
                trailing:
                    HeaderButton("plus") {
                        self.isSheet = true
                    }
            )
            .sheet(isPresented: $isSheet) {
                AddHabit()
                    .environmentObject(appSetting)
                    .environmentObject(habitManager)
                    .environmentObject(summaryManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if appSetting.isFirstRun && habitManager.contents.isEmpty {
                isSheet = true
            }
            if TimerManager.isRunning {
                timerReopen = true
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HabitList_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = PreviewDataProvider.shared
        return HabitList()
            .environmentObject(AppSetting())
            .environmentObject(coredataPreview.habitManager)
    }
}
