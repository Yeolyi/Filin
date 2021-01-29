//
//  HabitWidget.swift
//  HabitWidget
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    
    /// 다음 날 정보를 보여줄 시간 설정. 시간 단위. 기본값 0(24시)
    @AutoSave("dayResetTime", defaultValue: 0)
    var dayResetTime: Int
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let intent = SelectWidgetHabitIntent()
        if !WidgetBridge.todayAchievements.isEmpty {
            let firstHabit = WidgetBridge.todayAchievements[0]
            let habitCompact = HabitCompact(identifier: firstHabit.id.uuidString, display: firstHabit.name)
            habitCompact.name = firstHabit.name
            intent.habit = habitCompact
        } else {
            let id = UUID()
            WidgetBridge.todayAchievements = [
                HabitWidgetData(
                    id: id, name: "Stretching".localized,
                    numberOfTimes: 10, current: 6, colorHex: ThemeColor.colorList[0].hex, day: 1
                )
            ]
            let habitCompact = HabitCompact(identifier: id.uuidString, display: "Stretching".localized)
            intent.habit = habitCompact
        }
        let entry = SimpleEntry(date: Date(), configuration: intent)
        completion(entry)
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        var nextDate = Calendar.current.date(bySettingHour: dayResetTime, minute: 0, second: 0, of: Date())!
        nextDate = nextDate.addingTimeInterval(86400)
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        let nextEntry = SimpleEntry(date: nextDate, configuration: configuration)
        let timeline = Timeline(entries: [entry, nextEntry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    let date: Date
    let configuration: ConfigurationIntent
}

@main
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"
    typealias ConfigurationIntent = SelectWidgetHabitIntent
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HabitWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Today's goal".localized)
        .description("Check the progress of the goal at a glance.")
    }
}

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    func addDate(_ num: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = num
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: self)
    }
}
