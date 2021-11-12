//
//  SettingsTableViewCellModel.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 01.11.2021.
//  

import Foundation

class SettingsTableViewCellModel {
    var cellType: SettingsRowType
    var imageName: String
    var text: String

    var action: ((Bool?) -> Void)?

    init(cellType: SettingsRowType, imageName: String, text: String) {
        self.cellType = cellType
        self.imageName = imageName
        self.text = text
    }
}
