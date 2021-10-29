//
//  CoreDataManager+Currency.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation

extension CoreDataManager {
    
    func populateCurrency() {
        for item in Constants.defaultCurrencyItems {
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
}

// MARK: - Constants
extension CoreDataManager {
    private enum Constants {
        static let defaultCurrencyItems = [
            (symbol: "$", name: "United State Dollar"),
            (symbol: "₽", name: "Russian Ruble"),
            (symbol: "£", name: "British Pound"),
            (symbol: "¥", name: "Japanese Yen"),
            (symbol: "€", name: "Euro")
        ]
    }
}
