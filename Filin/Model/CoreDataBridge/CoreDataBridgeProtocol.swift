//
//  ContextEditable.swift
//  Filin
//
//  Created by SEONG YEOL YI on 2021/01/09.
//

import SwiftUI
import CoreData

/// CoreData에 저장된 데이터를 사용하기 편한 형태로 변환.
/// - Note: context와 fetched를 연산 프로퍼티로 선언해도 괜찮을까? remove 함수가 다 다른건 어떡할까.
///         CoreData와 관련된 연산은 초기화와 저장 단계에서만 이루어짐.
protocol CoreDataBridge: ObservableObject {
    
    associatedtype CoreDataType: NSManagedObject, Identifiable
    associatedtype InAppType: Identifiable
    
    var contents: [InAppType] { get set }
    var moc: NSManagedObjectContext { get }
    var fetched: [CoreDataType] { get }
    
    func mocSave()
    func save()
    
}

extension CoreDataBridge {
    
    var moc: NSManagedObjectContext {
        let appDelegate: AppDelegate = {UIApplication.shared.delegate as! AppDelegate}()
        return appDelegate.persistentContainer.viewContext
    }
    
    var fetched: [CoreDataType] {
        let entityName = String(describing: CoreDataType.self)
        let fetchRequest = NSFetchRequest<CoreDataType>(entityName: entityName)
        if let fetched = try? moc.fetch(fetchRequest) {
            return fetched
        } else {
            assertionFailure()
            return []
        }
    }
    
    func mocSave() {
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
            assertionFailure()
        }
    }
}
