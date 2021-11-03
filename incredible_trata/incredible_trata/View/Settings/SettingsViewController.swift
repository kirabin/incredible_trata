//
//  SettingsViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//  

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var settingsView: UIView = {
        let view = SettingsView()
        view.tableView.delegate = self
        view.tableView.dataSource = self        
        return view
    }()
    
    override func loadView() {
        view = UIView()
        title = Constants.settingsTitle
        view.backgroundColor = Color.mainBG
        view.addSubview(settingsView)
        setConstrainst()
    }
    
    func setConstrainst() {
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.settingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.settingItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        let cellModel = Constants.settingItems[indexPath.section][indexPath.row]
        let rowsNumber = tableView.numberOfRows(inSection: indexPath.section)
        
        if indexPath.row == 0 && indexPath.row == rowsNumber - 1 {
            cell.roundSide = .all
        } else if indexPath.row == 0 {
            cell.roundSide = .top
        } else if indexPath.row == rowsNumber - 1 {
            cell.roundSide = .bottom
        }
        cell.configure(viewModel: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    private enum Constants {
        static let settingsTitle = "Settings"
        static let rowHeight: CGFloat = 70 // duplicate of SettingsCell.Constants
        static let settingItems: [[SettingsCellModel]] = [
            [SettingsCellModel(cellType: .blank, imageName: "tray.and.arrow.down", text: "Import"),
             SettingsCellModel(cellType: .blank, imageName: "tray.and.arrow.up", text: "Export")],
            [SettingsCellModel(cellType: .nested, imageName: "tag", text: "Categories"),
             SettingsCellModel(cellType: .nested, imageName: "dollarsign.circle", text: "Currencies")],
            [SettingsCellModel(cellType: .nested, imageName: "paintbrush", text: "Appearance")],
            [SettingsCellModel(cellType: .blank, imageName: "bubble.right", text: "Siri Shortcuts"),
             SettingsCellModel(cellType: .nested, imageName: "app.badge", text: "Notifications")],
            [SettingsCellModel(cellType: .toggle, imageName: "rectangle.stack", text: "Enable Hints"),
             SettingsCellModel(cellType: .blank, imageName: "hand.raised", text: "Setup Monthly Limit")]
        ]
    }
}
