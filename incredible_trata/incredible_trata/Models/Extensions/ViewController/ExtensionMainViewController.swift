//
//  ExtensionMainViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 25.10.2021.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return records.count

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
        cell.viewModel = records[indexPath.row]
        cell.imageView?.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsRecordViewController = SettingsRecordViewController()
        settingsRecordViewController.reloadRecord(inputRecord: records[indexPath.row])
        self.navigationController?.pushViewController(settingsRecordViewController, animated: true)
    }
}
