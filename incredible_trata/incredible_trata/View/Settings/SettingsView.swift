//
//  SettingsView.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 01.11.2021.
//  

import Foundation
import UIKit

class SettingsView: UIView {
    
    weak var delegate: UITableViewDelegate!
    weak var dataSource: UITableViewDataSource!
    
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: UITableView.Style.grouped)
        view.backgroundColor = Color.mainBG
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.separatorColor = Color.mainBG
        
        addSubview(tableView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sidePadding),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.sidePadding),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - Constants
extension SettingsView {
    private enum Constants {
        static let sidePadding: CGFloat = 24
    }
}
