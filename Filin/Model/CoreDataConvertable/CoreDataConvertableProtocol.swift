//
//  CoreDataConvertableProtocol.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/23.
//

import SwiftUI
import CoreData

protocol CoreDataConvertable: ObservableObject, Identifiable {
    associatedtype MatchingCoreDataType: NSManagedObject, Identifiable
    func coreDataTransfer(to target: MatchingCoreDataType)
}
