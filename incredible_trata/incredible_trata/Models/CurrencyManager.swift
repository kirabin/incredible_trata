//
//  CurrencyModel.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation
import UIKit
import CoreData

func deleteAllData(entity: String) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
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

class CurrencyManager {

    static let shared = CurrencyManager()

    init() {
        deleteAllData(entity: Constants.entityName)
    }
    
    private func isPopulated() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        
        do {
            let currencyItems = try managedContext.fetch(fetchRequest)
            return !currencyItems.isEmpty
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func populateIfNeeded() {
        guard !isPopulated() else { return }
        
        print("Prepopulating Currency Model")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.entityName,
                                                in: managedContext)!

        for item in Constants.items {
            let itemObject = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
            itemObject.setValue(item.symbol, forKey: Constants.symbolFieldName)
            itemObject.setValue(item.name, forKey: Constants.nameFieldName)
            itemObject.setValue(UUID(), forKey: Constants.idFieldName)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        SettingsManager.shared.currency = Constants.items[3]
        
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
                    print(item.value(forKey: Constants.nameFieldName)!,
                          item.value(forKey: Constants.symbolFieldName)!)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Constants
extension CurrencyManager {
    private enum Constants {
        static let entityName = "Currency"
        static let nameFieldName = "name"
        static let symbolFieldName = "symbol"
        static let idFieldName = "id"
        static let items: [CurrencyType] = [
            CurrencyType(symbol: "$", name: "United State Dollar"),
            CurrencyType(symbol: "₽", name: "Russian Ruble"),
            CurrencyType(symbol: "£", name: "British Pound"),
            CurrencyType(symbol: "¥", name: "Japanese Yen"),
            CurrencyType(symbol: "€", name: "Euro")
        ]
    }
}
