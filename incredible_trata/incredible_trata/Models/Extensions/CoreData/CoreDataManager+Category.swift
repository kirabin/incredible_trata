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
    }

    func fillingAllCategories() {
        for category in Default.categories {
            creatCategory(lableName: category.lableName, imageName: category.imageName)
        }
    }

    func getAllCategories() -> [Category] {
        do {
            let categories = try context.fetch(Category.fetchRequest())
            return categories
        } catch {
            print("An error ocurred while saving: \(error.localizedDescription)")
        }
        return []
    }

    func findCategory(viewContext: NSManagedObjectContext, object: Category) -> Category? {
        do {
            let objects = try viewContext.fetch(type(of: object).fetchRequest())
            for temp in objects where temp.objectID == object.objectID {
                    return temp
            }
        } catch {
            print("An error ocurred while saving: \(error.localizedDescription)")
        }
        return nil
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
