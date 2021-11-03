//
//  CoreDataManager+UserSettings.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation

extension CoreDataManager {
    
    private func getUserSettings() -> UserSettings {
        // TODO: handle try!
        let userSettingsItems = try! context.fetch(UserSettings.fetchRequest())
        
        if userSettingsItems.isEmpty {
            return UserSettings.create(in: context)
        } else {
            return userSettingsItems[0]
        }
    }
    
    func getUserSelectedCurrency() -> Currency? {
        return getUserSettings().currency
    }
    
    func setUserSettings() {
        let userSettings = getUserSettings()
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
