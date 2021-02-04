//
//  Main.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/11.
//

import SwiftUI

enum DetailViewActiveSheet: Identifiable {
    case edit, emoji, share
    var id: UUID {
        UUID()
    }
}

struct HabitDetailView: View {
    
    @ObservedObject var emojiManager = EmojiManager()
    
    @State var activeSheet: DetailViewActiveSheet?
    @State var selectedDate = Date()
    @State var isEmojiView = false
    @State var isCalendarExpanded = false
    
    @EnvironmentObject var habit: FlHabit
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var summaryManager: SummaryManager
    
    init(habit: FlHabit) {
        if !habit.isDaily {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek).map {Int($0)}))
        }
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HabitCalendar(
                    selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                    isExpanded: $isCalendarExpanded, habits: .init(contents: [habit])
                )
                DailyProgressBar(selectedDate: selectedDate, isEmojiMode: $isEmojiView)
                EmojiPicker(
                    selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                    habit: habit, emojiManager: emojiManager, activeSheet: $activeSheet
                )
                HabitStatistics()
                Text("")
                    .font(.system(size: 30))
            }
        }
        .padding(.top, 1)
        .navigationBarTitle(Text(habit.name))
        .navigationBarItems(
            trailing:
                HStack {
                    HeaderButton("square.and.arrow.up") {
                        activeSheet = DetailViewActiveSheet.share
                    }
                    HeaderText("Edit".localized) {
                        activeSheet = DetailViewActiveSheet.edit
                    }
                }
        )
        .sheet(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditHabit(targetHabit: habit)
                    .environmentObject(habitManager)
                    .environmentObject(summaryManager)
            case .emoji:
                EmojiListEdit()
                    .environmentObject(emojiManager)
            case .share:
                HabitShare(
                    target: { imageAspect in
                        ImageMaker(imageSize: imageAspect) {
                            HabitCalendar(
                                selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                                isExpanded: $isCalendarExpanded, habits: .init(contents: [habit]), isCapture: true
                            )
                            .environmentObject(appSetting)
                        }
                    },
                    aspectPolicy: {
                        !($0 == .fourThree && isCalendarExpanded)
                    }
                )
                    .environmentObject(appSetting)
            }
        }
        .onAppear {
            selectedDate = appSetting.mainDate
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSample = DataSample.shared
        return HabitDetailView(habit: FlHabit.habit1)
            .environmentObject(dataSample.habitManager)
            .environmentObject(dataSample.summaryManager)
            .environmentObject(FlHabit.habit1)
            .environmentObject(AppSetting())
    }
}
