//
//  Currency+CoreDataProperties.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 28.10.2021.
//
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

}

extension Currency : Identifiable {

}
