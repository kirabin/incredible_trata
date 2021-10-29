//
//  CoreDataManager+Record.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation
import CoreData

extension CoreDataManager {
    
    func saveRecord(note: String, amount: Int64, currency: Currency) throws {
        
        let record = Record.create(in: context)
        record.id = UUID()
        record.creation_date = Date()
        record.note = note
        record.amount = amount
        record.currency = currency
        
        currency.addToRecords(record)
        try context.save()
        
        // Debugging part
        let records = try! context.fetch(Record.fetchRequest())
        for record in records {
            print(record.note!, record.amount, record.currency!.name!)
        }
    }
}
