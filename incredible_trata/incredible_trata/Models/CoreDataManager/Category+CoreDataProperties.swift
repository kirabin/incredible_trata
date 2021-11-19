//
//  Category+CoreDataProperties.swift
//  incredible_trata
//
//  Created by Aristova Alina on 29.10.2021.
//
//

import Foundation
import CoreData

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var lableName: String?
    @NSManaged public var records: NSSet?
    @NSManaged public var nestedCategories: NSSet?
    @NSManaged public var parentCategory: Category?

    var nestedCategoriesArray: [Category] {
        self.nestedCategories?.allObjects as? [Category] ?? []
    }
}

// MARK: Generated accessors for records
extension Category {
    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)
}

// MARK: Generated accessors for nestedCategories
extension Category {
    @objc(addNestedCategoriesObject:)
    @NSManaged public func addToNestedCategories(_ value: Category)

    @objc(removeNestedCategoriesObject:)
    @NSManaged public func removeFromNestedCategories(_ value: Category)

    @objc(addNestedCategories:)
    @NSManaged public func addToNestedCategories(_ values: NSSet)

    @objc(removeNestedCategories:)
    @NSManaged public func removeFromNestedCategories(_ values: NSSet)
}

extension Category: Identifiable {}
