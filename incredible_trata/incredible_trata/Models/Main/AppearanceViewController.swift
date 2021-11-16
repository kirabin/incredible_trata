//
//  AppearanceViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 09.11.2021.
//  
//

import Foundation
import UIKit

class AppearanceViewController: UIViewController {

    var appearanceItems: [[AppearanceTableViewCellModel]] = []

    func creatappearanceItems() -> [[AppearanceTableViewCellModel]] {
        var sections: [[AppearanceTableViewCellModel]] = []
        AppearanceSection.appearances.forEach { section in
            var rows: [AppearanceTableViewCellModel] = []

            section.rows.forEach { row in
                let model: AppearanceTableViewCellModel?
                if case row = Theme.current {
                   model = AppearanceTableViewCellModel(cellType: row.type,
                                                             text: row.text, switched: false)
                } else {
                    model = AppearanceTableViewCellModel(cellType: row.type,
                                                             text: row.text, switched: true)
                }

                model?.action = { [weak self] _ in
                    guard let self = self else { return }
                    switch row {
                    case .system:
                        self.sistemOn()
                    case .light:
                        self.lightOn()
                    case .dark:
                        self.darkOn()
                    }
                    self.appearanceItems = self.creatappearanceItems()
                    self.appearanceTableView.reloadData()
                }
                rows.append(model!)
            }
            sections.append(rows)
        }
        return sections
    }

    @objc func darkOn() {
        Theme.dark.setActive()
    }

    @objc func lightOn() {
        Theme.light.setActive()
    }

    @objc func sistemOn() {
        Theme.system.setActive()
    }

    override func viewDidLoad() {
        title = Constants.appearanceTitle
        view.backgroundColor = Color.mainBG
        view.addSubview(appearanceTableView)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                                    Color.addButtonBG]
        appearanceItems = creatappearanceItems()
        setConstrainst()
    }

    private lazy var appearanceTableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.backgroundColor = Color.mainBG
        return view
    }()

    func setConstrainst() {
        appearanceTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appearanceTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appearanceTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            appearanceTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Constants.sidePadding),
            appearanceTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Constants.sidePadding)
        ])
    }
}

extension AppearanceViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return appearanceItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appearanceItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AppearanceTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }
        let cellModel = appearanceItems[indexPath.section][indexPath.row]
        cell.configure(viewModel: cellModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = appearanceItems[indexPath.section][indexPath.row]
        if let action = item.action {
            action(nil)
        }
    }
}

// MARK: - Constants
extension AppearanceViewController {
    private enum Constants {
        static let appearanceTitle = "Appearance"
        static let sidePadding: CGFloat = 24
    }
}
