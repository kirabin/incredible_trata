//
//  RecordModel.swift
//  incredible_trata
//
//  Created by a19658227 on 27.10.2021.
//

import Foundation

class RecordModel {
    var id: UUID
    var currencyID: UUID
    var categoryID: UUID
    var creationDate: Date
    var note: String
    var amount: Int
    
    init (note: String, amount: Int, categoryId: UUID, currencyId: UUID) {
        self.id = UUID()
        self.creationDate = Date()
        self.note = note
        self.amount = amount
        self.categoryID = categoryId
        self.currencyID = currencyId
    }
}
