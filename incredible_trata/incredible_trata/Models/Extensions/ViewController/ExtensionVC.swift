//
//  ExtensionVC.swift
//  incredible_trata
//
//  Created by Aristova Alina on 25.10.2021.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        groupSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemsInfoArrays[section].count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! CustomCell
        let i = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0 {
            cell.indexCell.first = true
        }
        if  indexPath.row == i - 1 {
            cell.indexCell.last = true
        }
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.imageView?.image = nil
        return cell
    }
}
