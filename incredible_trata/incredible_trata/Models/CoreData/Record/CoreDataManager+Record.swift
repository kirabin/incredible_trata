//
//  CoreDataManager+Record.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation
import CoreData

extension CoreDataManager {
    
    func saveRecord(note: String, amount: Int64, currency: Currency, category: Category,
                    longitude: Double, latitude: Double) throws {
        let record = Record.create(in: context)
        record.id = UUID()
        record.creation_date = Date()
        record.note = note
        record.amount = amount
        record.currency = currency
        record.category = category
        record.latitudeCoordinate = latitude
        record.longitudeCoordinate = longitude
        
        currency.addToRecords(record)
        category.addToRecord(record)
        try context.save()
    }
    
    func save(_ record: Record) throws {
        try context.save()
    }
    
    func getAllRecord() -> [Record] {
        let record = try! context.fetch(Record.fetchRequest())
        return record
    }
    
    func FindRecord(viewContext: NSManagedObjectContext, record: Record) -> Record? {
        let records = try! viewContext.fetch(Record.fetchRequest())
        for temp in records {
            if temp.objectID == record.objectID {
                return temp
            }
        }
        return nil
    }
}
