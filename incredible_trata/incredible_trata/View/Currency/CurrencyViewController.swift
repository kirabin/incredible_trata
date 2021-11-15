//
//  CurrencyViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 03.11.2021.
//  

import Foundation
import UIKit

class CurrencyViewController: UIViewController {
    
    private lazy var currencyItems: [Currency]? = CoreDataManager.shared.getCurrencies()
    
    private lazy var currencyList: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(CurrencyTableViewCell.self,
                      forCellReuseIdentifier: Constants.cellReuseIdentifier)
        view.backgroundColor = Color.mainBG
        view.separatorColor = Color.mainBG
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency"
        view.backgroundColor = Color.mainBG
        view.addSubview(currencyList)
        setConstraints()
    }
    
    func setConstraints() {
        currencyList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyList.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Constants.cellSidePadding),
            currencyList.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Constants.cellSidePadding),
            currencyList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier,
                                                      for: indexPath) as? CurrencyTableViewCell else {
           fatalError()
       }
        let rowsNumber = tableView.numberOfRows(inSection: indexPath.section)
        
        if let currencyItem = currencyItems?[indexPath.row] {
            cell.configure(text: currencyItem.name! + " - " + currencyItem.symbol!)
        }
        if indexPath.row == 0 && indexPath.row == rowsNumber - 1 {
            cell.roundSide = .all
        } else if indexPath.row == 0 {
            cell.roundSide = .top
        } else if indexPath.row == rowsNumber - 1 {
            cell.roundSide = .bottom
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currencyItem = currencyItems?[indexPath.row] {
            CoreDataManager.shared.setUserSelected(currencyItem)
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Constants
extension CurrencyViewController {
    private enum Constants {
        static let cellReuseIdentifier = "currencyCell"
        static let cellSidePadding: CGFloat = 15
    }
}
