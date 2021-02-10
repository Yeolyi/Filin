//
//  IntentHandler.swift
//  WidgetIntentsExtension
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import Intents

class IntentHandler: INExtension, SelectWidgetHabitIntentHandling {
    
    @AutoSave("todayAchievements", defaultValue: [])
    var todayAchievements: [HabitWidgetData]
    
    func provideHabitOptionsCollection(
        for intent: SelectWidgetHabitIntent,
        with completion: @escaping (INObjectCollection<HabitCompact>?, Error?) -> Void
    ) {
        let widgetHabitNames: [HabitCompact] = todayAchievements.map { widgetHabit in
            let widgetHabitName = HabitCompact(
                identifier: widgetHabit.id.uuidString, display: widgetHabit.name
            )
            widgetHabitName.name = widgetHabit.name
            return widgetHabitName
        }
        let collection = INObjectCollection(items: widgetHabitNames)
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
