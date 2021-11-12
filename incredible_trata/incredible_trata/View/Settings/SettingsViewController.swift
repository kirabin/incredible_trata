//
//  SettingsViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//  

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Private Properties
    private lazy var settingItems: [[SettingsTableViewCellModel]] = {
        var sections: [[SettingsTableViewCellModel]] = []

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

    // MARK: - Subviews
    private lazy var settingsView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.backgroundColor = Color.mainBG
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = Color.mainBG
        view.addSubview(settingsView)
        setConstrainst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private Methods
    private func switchHints(_ isOn: Bool) {
        print(isOn)
    }

    private func setConstrainst() {
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Constants.sidePadding),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Constants.sidePadding)
        ])
    }

    private func currencyAction() {
        self.navigationController?.pushViewController(CurrencyViewController(), animated: true)
    }

    private func appearanceAction() {
        self.navigationController?.pushViewController(AppearanceViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SettingsTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }

        let cellModel = settingItems[indexPath.section][indexPath.row]

        cell.setRoundSide(tableView: tableView, indexPath: indexPath)
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
        static let sidePadding: CGFloat = 24
    }
}
