//
//  SettingsSections.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 03.11.2021.
//  

import Foundation

enum SettingsSection {
    case importExport
    case entity
    case appearance
    case system
    case additional
    
    static var sortedSections: [SettingsSection] = [
        .importExport,
        .entity,
        .appearance,
        .system,
        .additional
    ]
    
    var rows: [SettingsRow] {
        switch self {
            case .importExport:
                return [.importData, .exportData]
            case .entity:
                return [.category, .currency]
            case .appearance:
                return [.appearance]
            case .system:
                return [.siri, .notifications]
            case .additional:
                return [.hints, .monthlyLimit]
        }
    }
}

enum SettingsRow {
    case importData
    case exportData
    case category
    case currency
    case appearance
    case siri
    case notifications
    case hints
    case monthlyLimit
    
    var type: SettingsRowType {
        switch self {
            case .importData, .exportData, .siri, .monthlyLimit:
                return .blank
            
            case .category, .currency, .appearance, .notifications:
                return .nested
            
            case .hints:
                return .toggle
            
        }
    }
    
    var imageName: String {
        switch self {
        case .importData:
            return "tray.and.arrow.down"
            
        case .exportData:
            return "tray.and.arrow.up"
            
        case .category:
            return "tag"
            
        case .currency:
            return "dollarsign.circle"
            
        case .appearance:
            return "paintbrush"
            
        case .siri:
            return "bubble.right"
            
        case .notifications:
            return "app.badge"
            
        case .hints:
            return "rectangle.stack"
            
        case .monthlyLimit:
            return "hand.raised"
            
        }
    }
    
    var text: String {
        switch self {
        case .importData:
            return "Import"
            
        case .exportData:
            return "Export"
            
        case .category:
            return "Categories"
            
        case .currency:
            return "Currencies"
            
        case .appearance:
            return "Appearance"
            
        case .siri:
            return "Siri Shortcuts"
            
        case .notifications:
            return "Notifications"
            
        case .hints:
            return "Enable Hints"
            
        case .monthlyLimit:
            return "Setup Monthly Limit"
            
        }
    }
}

enum SettingsRowType {
    case blank
    case nested
    case toggle
    case check
}
