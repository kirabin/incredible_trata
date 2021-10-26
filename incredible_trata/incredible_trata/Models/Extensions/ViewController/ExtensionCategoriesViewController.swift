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
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! CategoryTableViewCell
        let i = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0 {
            cell.indexCell.first = true
        }
        if  indexPath.row == i - 1 {
            cell.indexCell.last = true
        }
        cell.viewModel = categories[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.imageView?.image = nil
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        delegate?.categoryWasSelected(category: categories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
