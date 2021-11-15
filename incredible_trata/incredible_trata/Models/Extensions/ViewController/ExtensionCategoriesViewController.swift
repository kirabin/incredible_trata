//
//  ExtensionCategoriesViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import Foundation
import UIKit

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as?
                CategoryTableViewCell else {
            fatalError()
        }
        let section = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0 && indexPath.row == section - 1 {
            cell.indexCell = (true, true)
        } else if indexPath.row == 0 {
            cell.indexCell = (true, false)
        } else if indexPath.row == section - 1 {
            cell.indexCell = (false, true)
        } else {
            cell.indexCell = (false, false)
        }
        cell.viewModel = categories[indexPath.row]
        cell.imageView?.image = nil
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categoryWasSelected(category: categories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
