//
//  Routine+CoreDataProperties.swift
//  
//
//  Created by SEONG YEOL YI on 2020/12/26.
//
//

import Foundation
import CoreData

extension Routine: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var id: UUID
    @NSManaged public var list: [UUID]
    @NSManaged public var name: String
    @NSManaged public var time: String?
    @NSManaged public var dayOfWeek: [Int16]

}
