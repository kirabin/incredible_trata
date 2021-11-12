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
            createCurrency(with: item)

            // TODO: should I save only once?
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    private func createCurrency(with item: (symbol: String, name: String)) {
        guard let obj = Currency.create(in: context) else {return}
        obj.symbol = item.symbol
        obj.name = item.name
        obj.id = UUID()
        return
    }

    func getCurrencies() -> [Currency]? {
        try? CoreDataManager.shared.context.fetch(Currency.fetchRequest())
    }
}
