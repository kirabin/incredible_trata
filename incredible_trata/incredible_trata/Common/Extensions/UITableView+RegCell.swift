//
//  UITableView+RegCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 16.11.2021.
//  

import UIKit

extension UITableView {
    func regCell<CellType: UITableViewCell>(indexPath: IndexPath) -> CellType? {
        let value = self.value(forKey: "_cellClassDict") as? [String: AnyObject]
        let reuseId = String(describing: CellType.self)

        if value == nil || value?[reuseId] == nil {
            self.register(CellType.self, forCellReuseIdentifier: reuseId)
        }
        let cell = self.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell as? CellType
    }
}
