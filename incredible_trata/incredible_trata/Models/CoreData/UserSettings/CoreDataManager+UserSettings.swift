//
//  CoreDataManager+UserSettings.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation

extension CoreDataManager {
    
    func getUserSettings() -> UserSettings {
        var items: [UserSettings] = []
        do {
            items = try context.fetch(UserSettings.fetchRequest())
        } catch let error as NSError {
            print("Couldn't fetch userSettings \(error), \(error.userInfo)")
        }

        if items.isEmpty {
            return setUserSettings()
        } else {
            return items[0]
        }
    }
    
    func getUserSelectedCurrencySymbol() -> String {
        getUserSettings().currency!.symbol!
    }
    
    func setUserSettings() -> UserSettings {
        let userSettings = UserSettings.create(in: context)
        let currencies = try! context.fetch(Currency.fetchRequest())
        
        if currencies.isEmpty {
            // TODO: How to better handle this?
        } else {
            userSettings.currency = currencies[0]
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return userSettings
    }
    
    func setUserSelected(_ currency: Currency) {
        let userSettings = getUserSettings()
        userSettings.currency = currency
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
