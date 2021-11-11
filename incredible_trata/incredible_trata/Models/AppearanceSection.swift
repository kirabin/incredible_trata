//
//  AppearanceSection.swift
//  incredible_trata
//
//  Created by Aristova Alina on 11.11.2021.
//  
//

import Foundation

enum AppearanceSection {
    case appearance
    static var appearances: [AppearanceSection] = [.appearance]
    
    var rows: [Theme] {
        switch self {

        case .appearance:
            return [.dark, .system, .light]
        }
    }
}

enum Theme: Int, CaseIterable {
    case light = 0
    case dark
    case system
    
    var type: SettingsRowType {
        switch self {
        case .system, .light, .dark:
            return .check
        }
    }
    
    var text: String {
        switch self {

        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}


