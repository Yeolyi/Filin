//
//  Localizing.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/21.
//

import SwiftUI

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}

extension Date {
    var localizedYearMonth: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(
            fromTemplate: "yyyyMMM", options: 0, locale: Locale.current
        ) ?? "yyyyMMM"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
    var localizedYearMonthDay: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(
            fromTemplate: "yyyyMMMd", options: 0, locale: Locale.current
        ) ?? "yyyyMMMd"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
    var localizedMonthDay: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale.current) ?? "MMMd"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
    var localizedHourMinute: String {
        let df = DateFormatter()
        let userFormat = DateFormatter.dateFormat(fromTemplate: "hh:mm a", options: 0, locale: Locale.current) ?? "MMMd"
        df.setLocalizedDateFormatFromTemplate(userFormat)
        return df.string(from: self)
    }
    static func dayOfTheWeekStr(_ num: Int) -> String {
        var dateCursor = Date()
        let currentDayOfWeek = dateCursor.dayOfTheWeek
        dateCursor = dateCursor.addDate(num-currentDayOfWeek)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: dateCursor)
    }
    static func dayOfTheWeekShortStr(_ num: Int) -> String {
        var dateCursor = Date()
        let currentDayOfWeek = dateCursor.dayOfTheWeek
        dateCursor = dateCursor.addDate(num-currentDayOfWeek)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: dateCursor)
    }
}
