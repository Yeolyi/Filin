//
//  CalendarSummaryView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

struct SummaryView: View {
    
    @State var updated = false
    @State var selectedDate = Date()
    @State var isSettingSheet = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summaryManager.contents.isEmpty || summaryManager.contents[0].isEmpty {
                        SummaryPreview(isSettingSheet: $isSettingSheet)
                    } else {
                        RingCalendar(
                            selectedDate: $selectedDate,
                            habit1: habitManager.contents.first(where: {$0.id == summaryManager.contents[0].first}),
                            habit2: habitManager.contents.first(where: {$0.id == summaryManager.contents[0].second}),
                            habit3: habitManager.contents.first(where: {$0.id == summaryManager.contents[0].third})
                        )
                        ForEach(summaryManager.contents[0].habitArray.compactMap({ id in
                            habitManager.contents.first(where: {
                                $0.id == id
                            })
                        }), id: \.id) { habit in
                            HabitRow(habit: habit, showAdd: false, date: selectedDate)
                        }
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary".localized)
            .navigationBarItems(
                trailing: HeaderText("Edit".localized) {
                    isSettingSheet = true
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isSettingSheet) {
            ProfileSettingView()
                .accentColor(ThemeColor.mainColor(colorScheme))
                .environmentObject(summaryManager)
                .environmentObject(habitManager)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .onAppear {
            selectedDate = appSetting.mainDate
        }
    }
}

/*
 struct CalendarSummaryView_Previews: PreviewProvider {
 static var previews: some View {
 _ = CoreDataPreview.shared
 return SummaryView()
 }
 }
 */
