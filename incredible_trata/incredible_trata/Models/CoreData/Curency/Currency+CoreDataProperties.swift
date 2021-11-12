//
//  Currency+CoreDataProperties.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 28.10.2021.
//

import Foundation
import CoreData

extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var records: NSSet?
    @NSManaged public var userSettings: UserSettings?

}

// MARK: Generated accessors for records
extension Currency {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

extension Currency: Identifiable {
}
