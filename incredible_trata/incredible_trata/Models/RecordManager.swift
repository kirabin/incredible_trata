//
//  RecordManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation
import UIKit
import CoreData

class RecordManager {
    
    static let shared = RecordManager()
    
    init() {
        deleteAllData(entity: "")
    }

    func saveRecord(record: RecordModel) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.entityName,
                                                in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        
        item.setValue(record.note, forKey: Constants.noteFieldName)
        item.setValue(record.amount, forKey: Constants.amountFieldName)
        item.setValue(record.id, forKey: Constants.idFieldName)
        item.setValue(record.creationDate, forKey: Constants.creationDateFieldName)
        item.setValue(record.categoryID, forKey: Constants.categoryIDFieldName)
        item.setValue(record.currencyID, forKey: Constants.currencyIDFieldName)
        
        // TODO: should I catch errors here?
        try managedContext.save()
        
        printAllData()
    }
    
    // For debugging
    private func printAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        
        do {
            let currencyItems = try managedContext.fetch(fetchRequest)
            if !currencyItems.isEmpty {
                for item in currencyItems {
                    print(item.value(forKey: Constants.noteFieldName)!,
                          item.value(forKey: Constants.amountFieldName)!)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Constants
extension RecordManager {
    private enum Constants {
        static let entityName = "Record"
        static let idFieldName = "id"
        static let categoryIDFieldName = "category_id"
        static let currencyIDFieldName = "currency_id"
        static let creationDateFieldName = "creation_date"
        static let amountFieldName = "amount"
        static let noteFieldName = "note"
    }
}
