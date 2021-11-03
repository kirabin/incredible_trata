//
//  CoreDataManager+Currency.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation

extension CoreDataManager {
    
    func populateCurrency(with items: [(symbol: String, name: String)]) {
        for item in items {
            let obj = Currency.create(in: context)
            obj.symbol = item.symbol
            obj.name = item.name
            obj.id = UUID()
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getCurrencies() -> [Currency]? {
        try? CoreDataManager.shared.context.fetch(Currency.fetchRequest())
    }
    
}
