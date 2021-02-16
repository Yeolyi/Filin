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
    
    @StateObject var emojiManager = EmojiManager()
    
    @State var activeSheet: DetailViewActiveSheet?
    @State var selectedDate = Date()
    @State var isEmojiView = false
    @State var isCalendarExpanded = false
    
    @EnvironmentObject var habit: FlHabit
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var appSetting: AppSetting
    @EnvironmentObject var summaryManager: SummaryManager
    @EnvironmentObject var routineManager: RoutineManager
    
    init(habit: FlHabit) {
        if !(habit.dayOfWeek.count == 7) {
            _selectedDate = State(initialValue: Date().nearDayOfWeekDate((habit.dayOfWeek).map {Int($0)}))
        }
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                HabitCalendar(
                    selectedDate: $selectedDate, isEmojiView: $isEmojiView,
                    isExpanded: $isCalendarExpanded, habits: .init(contents: [habit])
                )
                DailyProgressBar(selectedDate: selectedDate, isEmojiMode: $isEmojiView)
                EmojiPicker(
                    habit: habit, emojiManager: emojiManager, selectedDate: $selectedDate,
                    isEmojiView: $isEmojiView, activeSheet: $activeSheet
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
                HStack(spacing: 10) {
                    IconButton(imageName: "square.and.arrow.up") {
                        activeSheet = DetailViewActiveSheet.share
                    }
                    TextButton(content: { Text("Edit".localized) }) {
                        activeSheet = DetailViewActiveSheet.edit
                    }
                }
        )
        .fullScreenCover(item: $activeSheet) { item in
            switch item {
            case .edit:
                EditHabitCard(targetHabit: habit)
                    .environmentObject(habitManager)
                    .environmentObject(summaryManager)
                    .environmentObject(routineManager)
                    .environmentObject(appSetting)
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
        let dataSample = PreviewDataProvider.shared
        return HabitDetailView(habit: FlHabit.sample(number: 0))
            .environmentObject(dataSample.habitManager)
            .environmentObject(dataSample.summaryManager)
            .environmentObject(FlHabit.sample(number: 0))
            .environmentObject(AppSetting())
    }
}
