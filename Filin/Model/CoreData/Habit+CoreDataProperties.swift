//
//  HabitInfo+CoreDataProperties.swift
//  habitdiary
//
//  Created by SEONG YEOL YI on 2020/12/12.
//
//

import SwiftUI
import CoreData

extension Habit {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }
    
    @NSManaged public var achievement: [String: Int16]
    @NSManaged public var colorHex: String
    @NSManaged public var dayOfWeek: [Int16]
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var numberOfTimes: Int16
    @NSManaged public var dailyEmoji: [String: String]
    @NSManaged public var memo: [String: String]
    @NSManaged public var requiredSecond: Int16
    
}

extension Habit: Identifiable {
    
}
