//
//  ReminderDateExtension.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/02/14.
//

import Foundation

extension Date {
    init(hour: Int, minute: Int, isAM: Bool) {
        var components = DateComponents()
        let hour24: Int
        if isAM {
            hour24 = hour == 12 ? 0 : hour
        } else {
            hour24 = hour == 12 ? hour : hour + 12
        }
        components.hour = hour24
        components.minute = minute
        self = Calendar.current.date(from: components)!
    }
    func dateToTimer() -> (hour: Int, minute: Int, isAM: Bool) {
        let isAM = self.hour < 12
        let hour: Int
        if isAM {
            hour = self.hour == 0 ? 12 : self.hour
        } else {
            hour = self.hour - 12 == 0 ? 12 : self.hour - 12
        }
        return (hour, self.minute, isAM)
    }
}
