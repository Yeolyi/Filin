//
//  FLSummary+CoreDataProperties.swift
//  
//
//  Created by SEONG YEOL YI on 2021/02/03.
//
//

import Foundation
import CoreData

extension FlSummary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlSummary> {
        return NSFetchRequest<FlSummary>(entityName: "FlSummary")
    }

    @NSManaged public var id: UUID
    @NSManaged public var list: [UUID]
    @NSManaged public var name: String

}

extension FlSummary: Identifiable {
    
}
