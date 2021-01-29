//
//  CalendarRingDesign.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/24.
//

import SwiftUI

struct CalendarRingDesign {
    
    static func isButtonActive(at date: Date, habits: [FlHabit?]) -> Bool {
        if habits.compactMap({$0}).count != 1 {
            return true
        } else {
            return habits.compactMap({$0})[0].isTodo(at: date.dayOfTheWeek) == true
        }
    }
    
    static func getRingTuple(
        at date: Date, habits: [FlHabit?], selectedDate: Date, colorScheme: ColorScheme
    ) -> RingGroup {
        guard isButtonActive(at: date, habits: habits) else {
            return RingGroup([nil])
        }
        var tempRingTuple: [Ring?] = []
        for habit in habits {
            guard let habit = habit else {
                tempRingTuple.append(nil)
                continue
            }
            guard let progress = habit.achievement.progress(at: date), progress > 0 else {
                tempRingTuple.append(Ring(0, .clear))
                continue
            }
            let color = (selectedDate.month == date.month) ? habit.color : ThemeColor.subColor(colorScheme)
            tempRingTuple.append(Ring(progress, color))
        }
        if tempRingTuple.compactMap({$0}).isEmpty {
            let colorInactive = ThemeColor.subColor(colorScheme).opacity(0.05)
            tempRingTuple.append(Ring(1, colorInactive))
        }
        return RingGroup(tempRingTuple)
    }
    
    static func textColor(
        at date: Date, habits: [FlHabit?], selectedDate: Date, isExpanded: Bool, colorScheme: ColorScheme
    ) -> Color {
        guard isButtonActive(at: date, habits: habits) else {
            return ThemeColor.subColor(colorScheme)
        }
        if selectedDate.month != date.month && isExpanded {
            return ThemeColor.subColor(colorScheme)
        } else if habits.compactMap({$0}).count == 0 {
            return ThemeColor.mainColor(colorScheme)
        } else if date.dictKey == selectedDate.dictKey {
            if let colorHex = habits[0]?.color {
                return colorHex
            } else {
                return ThemeColor.subColor(colorScheme)
            }
        }
        return ThemeColor.mainColor(colorScheme)
    }
}
