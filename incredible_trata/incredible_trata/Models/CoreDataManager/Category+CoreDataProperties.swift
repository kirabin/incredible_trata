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
}
    
extension Category : Identifiable {

}
