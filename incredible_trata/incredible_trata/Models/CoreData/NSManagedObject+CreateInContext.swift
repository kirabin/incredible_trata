//
//  NSManagedObject+CreateInContext.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 28.10.2021.
//

import Foundation
import CoreData


extension NSManagedObject {
    class func create(in context: NSManagedObjectContext) -> Self {
        NSEntityDescription.insertNewObject(forEntityName: String(describing: self),
                                            into: context) as! Self
    }
    
    // TODO: find or create
}
