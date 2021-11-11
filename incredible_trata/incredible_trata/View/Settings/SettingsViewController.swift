//
//  SettingsViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//  

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    lazy var settingItems: [[SettingsTableViewCellModel]] = {
        var sections:[[SettingsTableViewCellModel]] = []
        
        SettingsSection.sortedSections.forEach { section in
            var rows: [SettingsTableViewCellModel] = []
            
            section.rows.forEach { row in
                let model = SettingsTableViewCellModel(cellType: row.type,
                                                       imageName: row.imageName,
                                                       text: row.text)

                model.action = { [weak self] isOn in
                    switch row {
                    case .hints:
                        self?.switchHints(isOn ?? false)
                            
                    case .currency:
                        self?.currencyAction()
                            
                    case .importData, .exportData, .category,
                             .siri, .notifications,
                                .monthlyLimit:
                        break
                    case .appearance:
                        self?.appearanceAction()
                        
                    }
                }
                rows.append(model)
            }
            sections.append(rows)
        }
        return sections
    }()
    
    func switchHints(_ isOn: Bool) {
        print(isOn)
    }
    
    func currencyAction() {
        self.navigationController?.pushViewController(CurrencyViewController(), animated: true)
    }
    
    func appearanceAction() {
        self.navigationController?.pushViewController(AppearanceViewController(), animated: true)
    }
    
    private lazy var settingsView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.grouped)
        view.delegate = self
        view.dataSource = self
        view.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
        view.separatorColor = Color.mainBG
        view.backgroundColor = Color.mainBG
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
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Constants.sidePadding),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Constants.sidePadding),
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingsCellReusableIdentifier,
                                                 for: indexPath) as! SettingsTableViewCell
        let cellModel = settingItems[indexPath.section][indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingItems[indexPath.section][indexPath.row]
        guard item.cellType != .toggle else {return}
        
        if let action = item.action {
            action(nil)
        }
    }

}

// MARK: - Constants
extension SettingsViewController {
    private enum Constants {
        static let settingsTitle = "Settings"
        static let settingsCellReusableIdentifier = "settingsCell"
        static let sidePadding: CGFloat = 24
    }
}
