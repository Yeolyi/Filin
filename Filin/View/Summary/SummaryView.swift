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
        let temp = summaryManager.contents[0].list.compactMap { id in
            habitManager.contents.first(where: {
                $0.id == id
            })
        }
        return temp
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summaryManager.contents.isEmpty || summaryManager.contents[0].list.isEmpty {
                        SummaryPreview(isSettingSheet: $isSettingSheet)
                    } else {
                        if habits.count <= 3 && appSetting.calendarMode == .ring {
                            HabitCalendar(
                                selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                                isCalendarExpanded: $isCalendarExpanded, habits: .init(contents: habits)
                            )
                        } else {
                            HabitCalendarTable(
                                isExpanded: $isCalendarExpanded, isEmojiView: $isEmojiView,
                                               selectedDate: $selectedDate, habits: .init(contents: habits)
                            )
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
            EditSummary(habits: habitManager.contents, current: habits)
                .accentColor(ThemeColor.mainColor(colorScheme))
                .environmentObject(summaryManager)
        }
        .accentColor(ThemeColor.mainColor(colorScheme))
        .onAppear {
            selectedDate = appSetting.mainDate
        }
    }
}

struct CalendarSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = DataSample.shared
        return SummaryView()
            .environmentObject(dataSample.habitManager)
            .environmentObject(dataSample.summaryManager)
            .environmentObject(AppSetting())
    }
}
