//
//  Summary+CoreDataProperties.swift
//  
//
//  Created by SEONG YEOL YI on 2020/12/26.
//
//

import Foundation
import CoreData

extension Summary: Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var first: UUID?
    @NSManaged public var second: UUID?
    @NSManaged public var third: UUID?
    
}
