//
//  CurrencyViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 03.11.2021.
//

import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Private Properties
    private lazy var currencyItems: [Currency]? = CoreDataManager.shared.getCurrencies()

    // MARK: - Subviews
    private lazy var currencyList: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = Color.mainBG
        view.separatorStyle = .none
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency"
        view.backgroundColor = Color.mainBG
        view.addSubview(currencyList)
        setConstraints()
    }

    // MARK: - Private Methods
    private func setConstraints() {
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CurrencyTableViewCell = tableView.regCell(indexPath: indexPath),
              let currency = currencyItems?[indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.setRoundSide(tableView: tableView, indexPath: indexPath)
        cell.configure(text: (currency.name ?? "") + " - " + (currency.symbol ?? ""))
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
        static let cellSidePadding: CGFloat = 15
    }
}
