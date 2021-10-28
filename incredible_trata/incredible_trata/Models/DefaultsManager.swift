//
//  DefaultsManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation
import CoreData

func countItems(managedObject: NSManagedObject.Type) -> Int {
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    
    do {
        let currencyItems = try managedContext.fetch(managedObject.fetchRequest())
        return currencyItems.count
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return 0
}

class DefaultManager {
    
    static let shared = DefaultManager()
    
    func populateCurrencyIfNeeded() {
        guard countItems(managedObject: Currency.self) == 0 else { return }
        
        CoreDataManager.shared.populateCurrency()
        CoreDataManager.shared.setCurrency()
    }
    // C
}

// MARK: - Constants
extension DefaultManager {
    private enum Constants {
        
    }
}
