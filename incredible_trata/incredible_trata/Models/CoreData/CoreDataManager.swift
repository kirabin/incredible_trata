//
//  CoreDataManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.

import Foundation
import CoreData

func deleteAllData(entity: String) {
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results {
            managedContext.delete(managedObject)
        }
    } catch let error as NSError {
        print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
    }
}


class CoreDataManager {
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static let shared = CoreDataManager()

    init() {
//        deleteAllData(entity: String(describing: Record.self))
//        deleteAllData(entity: String(describing: Currency.self))
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "incredible_trata")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveRecord(note: String, amount: Int64, currency: Currency) throws {
        
        let record = Record.create(in: context)
        record.note = note
        record.amount = amount
        record.currency = currency
        
        currency.addToRecords(record)
        try context.save()
        
        let records = try! context.fetch(Record.fetchRequest())
        for record in records {
            print(record.note!, record.amount, record.currency!.name!)
        }
    }
    
    func populateCurrency() {
        for item in Constants.Currency.items {
            let obj = Currency.create(in: context)
            obj.symbol = item.symbol
            obj.name = item.name
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func getCurrency() -> Currency? {
        
        let settings = try! context.fetch(UserSettings.fetchRequest()) // TODO: try!
        if settings.count >= 1 {
            return settings[0].currency
        }
        return nil
    }
    
    func setCurrency() {
        guard getCurrency() == nil else { return }
        
        let userSettings = UserSettings.create(in: context)
        
        let currencies = try! context.fetch(Currency.fetchRequest())
        userSettings.currency = currencies[0]
        try! context.save()
    }
}

// MARK: - Constants
extension CoreDataManager {
    private enum Constants {
        
        enum Record {
            static let idFieldName = "id"
            static let creationDateFieldName = "creation_date"
            static let amountFieldName = "amount"
            static let noteFieldName = "note"
        }
        enum Currency {
            static let nameFieldName = "name"
            static let symbolFieldName = "symbol"
            static let idFieldName = "id"
            static let items = [
                (symbol: "$", name: "United State Dollar"),
                (symbol: "₽", name: "Russian Ruble"),
                (symbol: "£", name: "British Pound"),
                (symbol: "¥", name: "Japanese Yen"),
                (symbol: "€", name: "Euro")
            ]
        }
    }
}
