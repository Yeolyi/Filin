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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Group {
                if habitManager.contents.isEmpty {
                    ListPreview(isAddSheet: $isSheet)
                } else {
                    HabitScrollView()
                }
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
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if appSetting.isFirstRun && habitManager.contents.isEmpty {
                isSheet = true
            }
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HabitList_Previews: PreviewProvider {
    static var previews: some View {
        let coredataPreview = DataSample.shared
        return HabitList()
            .environmentObject(AppSetting())
            .environmentObject(coredataPreview.habitManager)
    }
}
