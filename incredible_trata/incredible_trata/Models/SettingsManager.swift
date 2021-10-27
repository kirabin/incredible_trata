//
//  SettingsManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation

class SettingsManager {
    
    static var shared = SettingsManager()

    private let defaults = UserDefaults.standard
        
    var currency: CurrencyType {
        get {
            let data = defaults.value(forKey: Constants.currencyKeyName) as! Data
            return try! PropertyListDecoder().decode(CurrencyType.self, from: data)
        }
        set {
            defaults.set(try? PropertyListEncoder().encode(newValue),
                         forKey: Constants.currencyKeyName)
        }
    }
}

// MARK: - Constants
extension SettingsManager {
    private enum Constants {
        static let currencyKeyName = "currency"
    }
}
