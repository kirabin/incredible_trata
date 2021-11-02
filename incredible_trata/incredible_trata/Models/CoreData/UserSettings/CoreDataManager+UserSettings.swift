//
//  CoreDataManager+UserSettings.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//

import Foundation

extension CoreDataManager {
    
    func getCurrency() -> Currency? {
        do {
            let userSettings = try context.fetch(UserSettings.fetchRequest())
            return userSettings[0].currency
        } catch let error as NSError {
            print("Could not get Currency from User Settings. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func setUserSettings() {
        let userSettings = UserSettings.create(in: context)
        let currencies = try! context.fetch(Currency.fetchRequest())
        userSettings.currency = currencies[3]
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
