//
//  CoreDataManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.

import Foundation
import CoreData


class CoreDataManager {
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static let shared = CoreDataManager()

    init() {
//        deleteAllData(at: Record.self)
//        deleteAllData(at: Currency.self)
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllData(at entity: NSManagedObject.Type) {
        do {
            let results = try context.fetch(entity.fetchRequest())
            for managedObject in results {
                context.delete(managedObject as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
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
        for item in Constants.defaultCurrencyItems {
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

    // TODO: make'em safer
    func getCurrency() -> Currency {
        let userSettings = try! context.fetch(UserSettings.fetchRequest())
        return userSettings[0].currency!
    }
    
    func setCurrency() {
        let userSettings = UserSettings.create(in: context)
        let currencies = try! context.fetch(Currency.fetchRequest())
        userSettings.currency = currencies[3]
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Constants
extension CoreDataManager {
    private enum Constants {
        static let defaultCurrencyItems = [
            (symbol: "$", name: "United State Dollar"),
            (symbol: "₽", name: "Russian Ruble"),
            (symbol: "£", name: "British Pound"),
            (symbol: "¥", name: "Japanese Yen"),
            (symbol: "€", name: "Euro")
        ]
    }
}
