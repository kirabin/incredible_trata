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
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var childrenContext: NSManagedObjectContext {
        let childrenContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childrenContext.parent = context
        childrenContext.automaticallyMergesChangesFromParent = true
        return childrenContext
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getChildrenContext() -> NSManagedObjectContext {
        let childrenContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childrenContext.parent = context
        childrenContext.automaticallyMergesChangesFromParent = true
        return childrenContext
    }

    func savePrivateContext(_ privateContext: NSManagedObjectContext) throws {
        try privateContext.save()
        try context.save()
    }
}

extension NSPersistentContainer {
    func getContext() -> NSManagedObjectContext {
        return newBackgroundContext()
    }
}
