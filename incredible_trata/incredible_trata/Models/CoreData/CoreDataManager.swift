//
//  CoreDataManager.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 27.10.2021.

import Foundation
import CoreData


class CoreDataManager {
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
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
    
    private func deleteAllData(at entity: NSManagedObject.Type) {
        do {
            let results = try context.fetch(entity.fetchRequest())
            for managedObject in results {
                context.delete(managedObject as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
