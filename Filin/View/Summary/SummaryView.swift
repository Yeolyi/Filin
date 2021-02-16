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
    
    var isEmpty: Bool {
        summaryManager.contents.isEmpty || summaryManager.contents[0].list.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if isEmpty {
                        SummaryPreview(isRing: isRing)
                    } else {
                        HabitCalendar(
                            selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                            isExpanded: $isCalendarExpanded, habits: .init(contents: habits)
                        )
                    }
                }
            }
            .padding(.top, 1)
            .navigationBarTitle("Summary".localized)
            .navigationBarItems(
                trailing:
                    HStack(spacing: 10) {
                        IconButton(imageName: "square.and.arrow.up") {
                            activeSheet = SummaryViewActiveSheet.share
                        }
                        .opacity(isEmpty ? 0.5 : 1)
                        .disabled(isEmpty)
                        TextButton(content: { Text("Edit".localized) }) {
                            activeSheet = SummaryViewActiveSheet.edit
                        }
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditSummary()
                    .environmentObject(summaryManager)
                    .environmentObject(habitManager)
            case .share:
                HabitShare(
                    target: { imageAspect in
                        ImageMaker(imageSize: imageAspect) {
                            HabitCalendar(
                                selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                                isExpanded: $isCalendarExpanded, habits: .init(contents: habits), isCapture: true
                            )
                            .environmentObject(appSetting)
                        }
                    },
                    aspectPolicy: { imageSize in
                        switch imageSize {
                        case .free:
                            return true
                        default:
                            return !isCalendarExpanded
                        }
                    }
                )
            }
        }
        .onAppear {
            selectedDate = appSetting.mainDate
        }
        
    }
}

struct CalendarSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = PreviewDataProvider.shared
        return SummaryView()
            .environmentObject(dataSample.habitManager)
            .environmentObject(dataSample.summaryManager)
            .environmentObject(AppSetting())
    }
}
