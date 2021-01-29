//
//  CoreDataConvertableProtocol.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI
import CoreData

protocol CoreDataConvertable: ObservableObject, Identifiable {
    associatedtype Target: NSManagedObject, Identifiable
    func copyValues(to target: Target)
}
