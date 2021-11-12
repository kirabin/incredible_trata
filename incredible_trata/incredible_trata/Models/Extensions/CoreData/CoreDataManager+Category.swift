//
//  CoreDataManager+Category.swift
//  incredible_trata
//
//  Created by Aristova Alina on 29.10.2021.
//

import CoreData
import Foundation

extension CoreDataManager {

    func createCategory(lableName: String?, imageName: String?, parentCategory: Category?) {
        guard let category = Category.create(in: context) else {return}
        category.lableName = lableName
        category.imageName = imageName
        parentCategory?.addToNestedCategories(category)
        category.parentCategory = parentCategory

        do {
            try context.save()
        } catch {
            print("An error ocurred while saving: \(error.localizedDescription)")
        }
    }

    func fillingAllCategories() {
        for category in Default.categories {
            createCategory(lableName: category.lableName, imageName: category.imageName, parentCategory: nil)
        }
    }

    func getCategories(with predicate: NSPredicate? = nil) -> [Category] {
        let request = Category.fetchRequest()
        request.predicate = predicate

        var categories: [Category] = []
        do {
            categories = try context.fetch(request)
        } catch let error as NSError {
            print("Couldn't fetch categories \(error), \(error.userInfo)")
        }
        return categories
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
