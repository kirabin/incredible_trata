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

    @NSManaged public var imageName: String?
    @NSManaged public var lableName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var record: NSSet?

}

// MARK: Generated accessors for record
extension Category {

    @objc(addRecordObject:)
    @NSManaged public func addToRecord(_ value: Record)

    @objc(removeRecordObject:)
    @NSManaged public func removeFromRecord(_ value: Record)

    @objc(addRecord:)
    @NSManaged public func addToRecord(_ values: NSSet)

    @objc(removeRecord:)
    @NSManaged public func removeFromRecord(_ values: NSSet)

}

extension Category: Identifiable {
}
