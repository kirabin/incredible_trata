//
//  RecordManager.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 27.10.2021.
//

import Foundation
import UIKit
import CoreData

class RecordManager {
    
    static let shared = RecordManager()
    
    init() {
        deleteAllData(entity: Constants.entityName)
    }
}

// MARK: - Constants
