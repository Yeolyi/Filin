//
//  WidgetData.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/28.
//

import SwiftUI

struct HabitWidgetData: Codable {
    let id: UUID
    let name: String
    let numberOfTimes: Int
    let current: Int
    let colorHex: String
    let day: Int
}

class WidgetBridge {
    @AutoSave("todayAchievements", defaultValue: [])
    static var todayAchievements: [HabitWidgetData]
}
