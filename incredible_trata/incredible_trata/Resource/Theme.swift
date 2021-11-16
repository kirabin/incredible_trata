//
//  Theme.swift
//  incredible_trata
//
//  Created by Aristova Alina on 10.11.2021.
//
//

import Foundation
import UIKit

extension Theme {

    @Persist(key: "app_theme", defaultValue: Theme.system.rawValue)
    static var appTheme: Int

    func save() {
        Theme.appTheme = self.rawValue
    }

    static var current: Theme {
        Theme(rawValue: appTheme) ?? .system
    }
}

@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension Theme {

    @available(iOS 13.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return .unspecified
        }
    }

    func setActive() {
        save()
        guard #available(iOS 13.0, *) else { return }
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows
        window!.forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
    }
}
