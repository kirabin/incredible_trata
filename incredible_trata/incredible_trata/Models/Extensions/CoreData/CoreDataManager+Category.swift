//
//  CoreDataManager+Category.swift
//  incredible_trata
//
//  Created by Aristova Alina on 29.10.2021.
//

import CoreData
import Foundation

extension CoreDataManager {
    
    func creatCategory(lableName: String?, imageName: String?) {
        let category = Category.create(in: context)
        category.lableName = lableName
        category.imageName = imageName
        
        do {
            try context.save()
        } catch {
            print("An error ocurred while saving: \(error.localizedDescription)")
        }
        
        let categories = try! context.fetch(Category.fetchRequest())
        for category in categories {
            print(category.imageName!, category.lableName!)
        }
    }
    
    func fillingAllCategories() {
        for category in Default.categories {
            creatCategory(lableName: category.lableName, imageName: category.imageName)
        }
    }

    func delete(at entity: NSManagedObject.Type) {
        do {
            let results = try context.fetch(entity.fetchRequest())
            for managedObject in results {
                context.delete(managedObject as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func getAllCategories() -> [Category] {
        let categories = try! context.fetch(Category.fetchRequest())
        return categories
    }
}

// MARK: - Constants

extension CoreDataManager {
    private enum Default {
        static let categories = [(lableName: "Telephone", imageName: "candybarphone"),
                                 (lableName: "Internet", imageName: "wifi"),
                                 (lableName: "Trip", imageName: "airplane"),
                                 (lableName: "Car", imageName: "car.fill"),
                                 (lableName: "Home", imageName: "house"),
                                 (lableName: "Transport", imageName: "bus.fill"),
                                 (lableName: "Сlothes", imageName: "tshirt.fill")]
    }
}
