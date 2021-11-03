//
//  DefaultsManager.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 27.10.2021.
//

import Foundation
import CoreData


class DefaultsManager {
    
    static let shared = DefaultsManager()
    
    func populateCoreDataIfNeeded() {
        guard countItems(of: Currency.self) == 0 else { return }
        
        CoreDataManager.shared.populateCurrency()
        CoreDataManager.shared.setUserSettings()
    }
    
    func countItems(of managedObject: NSManagedObject.Type) -> Int {
        let managedContext = CoreDataManager.shared.context
        
        do {
            let currencyItems = try managedContext.fetch(managedObject.fetchRequest())
            return currencyItems.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
}
