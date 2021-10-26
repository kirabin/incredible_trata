//
//  ExtensionMainViewController.swift
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
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! RecordTableViewCell
        let i = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0 && indexPath.row == i - 1 {
            cell.indexCell = (true, true)
        }
        else if indexPath.row == 0 {
            cell.indexCell = (true, false)
        }
        else if indexPath.row == i - 1 {
            cell.indexCell = (false, true)
        } else {
            cell.indexCell = (false, false)
        }
        
        cell.imageView?.image = nil
        return cell
    }
}
