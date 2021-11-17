//
//  Date+Formatter.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 16.11.2021.
//  

import Foundation

extension Date {
    /// Trims date by keeping only components from parameter
    /// - Parameter components: components to keep in date
    /// - Returns: Trimmed date
    func trimTo(components: Calendar.Component...) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(Set(components), from: self)
        let date = Calendar.current.date(from: dateComponents) ?? self
        return date
    }

    /// Converts date to string using received format
    /// - Parameter format: dateFormatter string format (ex. "LLLL YYYY")
    /// - Returns: Converted date to string
    func convert(to format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
