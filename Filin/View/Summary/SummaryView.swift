//
//  CalendarSummaryView.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/20.
//

import SwiftUI

enum SummaryViewActiveSheet: Identifiable {
    case edit, share
    var id: UUID {
        UUID()
    }
}

struct SummaryView: View {
    
    @State var updated = false
    @State var selectedDate = Date()
    @State var activeSheet: SummaryViewActiveSheet?
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
    
    var isRing: Bool {
        habits.count <= 3 && appSetting.calendarMode == .ring
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if summaryManager.contents.isEmpty || summaryManager.contents[0].list.isEmpty {
                        
                    } else {
                        if isRing {
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
                trailing:
                    HStack {
                        HeaderButton("square.and.arrow.up") {
                            activeSheet = SummaryViewActiveSheet.share
                        }
                        HeaderText("Edit".localized) {
                            activeSheet = SummaryViewActiveSheet.edit
                        }
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditSummary(habits: habitManager.contents, current: habits)
                    .accentColor(ThemeColor.mainColor(colorScheme))
                    .environmentObject(summaryManager)
            case .share:
                HabitShare(target: { imageAspect in
                    if isRing {
                        CalendarWithLogo(
                            isExpanded: isCalendarExpanded, habits: .init(contents: habits),
                            imageAspect: imageAspect, isEmojiView: isEmojiView,
                            selectedDate: selectedDate, appSetting: appSetting
                        )
                    } else {
                        HabitCalendarTable(
                            isExpanded: $isCalendarExpanded, isEmojiView: $isEmojiView,
                            selectedDate: $selectedDate, habits: .init(contents: habits),
                            imageSize: imageAspect
                        )
                        .environmentObject(appSetting)
                    }
                }, aspectPolicy: { imageSize in
                    switch imageSize {
                    case .free:
                        return true
                    default:
                        return !isCalendarExpanded
                    }
                })
            }
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
