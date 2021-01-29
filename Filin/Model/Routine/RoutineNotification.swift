//
//  RoutineNotification.swift
//  Fillin
//
//  Created by SEONG YEOL YI on 2020/12/28.
//

import SwiftUI
import UserNotifications

extension FlRoutine {
    
    func addNoti(completion: @escaping (Bool) -> Void) {
        guard let time = self.time else {
            completion(false)
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard success else {
                print(error?.localizedDescription as Any)
                completion(false)
                return
            }
            let content = self.makeNotiContent(title: self.name, body: "Time to start routine.".localized)
            // Configure the recurring date.
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            for dayOfWeekComp in self.dayOfWeek {
                // identifier
                let uuidString = self.notiIDStr(withDayOfWeek: dayOfWeekComp)
                // trigger
                dateComponents.weekday = dayOfWeekComp
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: true
                )
                // Make request
                let request = UNNotificationRequest(
                    identifier: uuidString,
                    content: content,
                    trigger: trigger
                )
                // Schedule the request with the system.
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                }
            }
            completion(true)
        }
    }
    
    func deleteNoti() {
        let idList: [String] = Array(1...7).reduce(into: []) { result, dayOfWeek in
            result.append(self.id.uuidString + notiIDStr(withDayOfWeek: dayOfWeek))
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idList)
    }
    
    private func notiIDStr(withDayOfWeek dayOfWeek: Int) -> String {
        self.id.uuidString + String(dayOfWeek)
    }
    
    private func makeNotiContent(title: String, body: String, sound: UNNotificationSound = .default)
    -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        return content
    }
    
}
