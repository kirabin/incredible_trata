//
//  Record+CoreDataProperties.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 28.10.2021.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var creation_date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var longitudeCoordinate: Double
    @NSManaged public var latitudeCoordinate: Double
    @NSManaged public var category: Category?
    @NSManaged public var currency: Currency?

}

extension Record : Identifiable {

}
