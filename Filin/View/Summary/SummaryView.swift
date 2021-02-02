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
    @State var isEmojiView = false
    @State var isCalendarExpanded = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    
    var habits: [FlHabit] {
        summaryManager.contents[0].habitArray.compactMap { id in
            habitManager.contents.first(where: {
                $0.id == id
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summaryManager.contents.isEmpty || summaryManager.contents[0].isEmpty {
                        SummaryPreview(isSettingSheet: $isSettingSheet)
                    } else {
                        RingCalendar(selectedDate: $selectedDate, isEmojiView: $isEmojiView, isCalendarExpanded: $isCalendarExpanded, habits: .init(contents: habits))
                        ForEach(habits, id: \.id) { habit in
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
