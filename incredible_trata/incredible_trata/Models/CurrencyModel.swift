//
//  CurrencyModel.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation

struct CurrencyType: Encodable, Decodable {
    var symbol: String
    var name: String
    var id: UUID
    
    init(symbol: String, name: String) {
        self.id = UUID()
        self.symbol = symbol
        self.name = name
    }
}
