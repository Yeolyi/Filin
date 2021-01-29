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
///         CoreData와 관련된 연산은 초기화와 저장 단계에서 이루어짐. 
protocol DataBridge: ObservableObject {
    
    associatedtype Target: NSManagedObject, Identifiable
    associatedtype Converted: Identifiable
    
    var contents: [Converted] { get set }
    var fetched: [Target] { get }
    var moc: NSManagedObjectContext { get }
    
    func append(_ object: Converted)
    func mocSave()
}

extension DataBridge {
    
    var moc: NSManagedObjectContext {
        let appDelegate: AppDelegate = {UIApplication.shared.delegate as! AppDelegate}()
        return appDelegate.persistentContainer.viewContext
    }
    
    var fetched: [Target] {
        let entityName = String(describing: Target.self)
        let fetchRequest = NSFetchRequest<Target>(entityName: entityName)
        if let fetched = try? moc.fetch(fetchRequest) {
            return fetched
        } else {
            assertionFailure()
            return  []
        }
    }
    
    func mocSave() {
        do {
            try moc.save()
        } catch {
            assertionFailure()
        }
    }
}
