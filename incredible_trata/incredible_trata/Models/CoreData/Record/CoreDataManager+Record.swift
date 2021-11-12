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
        guard let record = Record.create(in: context) else {return}
        record.id = UUID()
        record.creationDate = Date()
        record.note = note
        record.amount = amount
        record.currency = currency
        record.category = category
        record.latitudeCoordinate = latitude
        record.longitudeCoordinate = longitude
        currency.addToRecords(record)
        category.addToRecords(record)
        try context.save()
    }

    func save(_ record: Record) throws {
        try context.save()
    }

    func findRecord(viewContext: NSManagedObjectContext, record: Record) -> Record? {
        do {
            let records = try viewContext.fetch(Record.fetchRequest())
            for temp in records where temp.objectID == record.objectID {
                    return temp
                }
        } catch let error as NSError {
            print("Could not get records with predicate. \(error), \(error.userInfo)")
        }
        return nil
    }

    func getRecords(with predicate: NSPredicate? = nil) -> [Record] {
        let request = Record.fetchRequest()
        request.predicate = predicate
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not get records with predicate. \(error), \(error.userInfo)")
        }
        return []
    }
}
