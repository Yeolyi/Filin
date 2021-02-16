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
    
    var body: some View {
        NavigationView {
            HabitScrollView()
            .navigationBarTitle(appSetting.mainDate.localizedMonthDay)
            .navigationBarItems(
                trailing:
                    IconButton(imageName: "plus") {
                        self.isSheet = true
                    }
            )
            .fullScreenCover(isPresented: $isSheet) {
                AddHabitCard()
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
