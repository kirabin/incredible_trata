//
//  SettingsCellModel.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 01.11.2021.
//  

import Foundation

enum SettingsCellType {
    case blank
    case nested
    case toggle
}

class SettingsCellModel {
    var cellType: SettingsCellType
    var imageName: String
    var text: String

    var switchAction: ((Bool) -> Void)?
    
    init(cellType: SettingsCellType, imageName: String, text: String) {
        self.cellType = cellType
        self.imageName = imageName
        self.text = text
    }
}
