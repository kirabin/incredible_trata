//
//  MonthSelectionViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 12.11.2021.
//  

import UIKit

protocol MonthSelectionViewControllerDelegate: AnyObject {
    func monthWasSelected(selectedDate: Date)
}

final class MonthSelectionViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: MonthSelectionViewControllerDelegate?

    // MARK: - Private Properties
    private var dates: [Date] = []

    private lazy var monthsTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self

        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 10
        }
        table.backgroundColor = Color.mainBG
        table.separatorStyle = .none
        return table
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(monthsTable)
        view.backgroundColor = Color.mainBG
        setConstraints()
        setData()
    }

    // MARK: - Private Methods
    private func setData() {
        let records = CoreDataManager.shared.getRecords()
        var dates = Array(Set(records.map {
            $0.creationDate?.trimTo(components: .month, .year) ?? Date()
        }))
        dates.sort(by: >)
        self.dates = dates
    }

    private func setConstraints() {
        monthsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthsTable.topAnchor.constraint(equalTo: view.topAnchor),
            monthsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tablePadding),
            monthsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tablePadding),
            monthsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MonthSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MonthSelectionTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }

        cell.configure(text: dates[indexPath.section].convert(to: "LLLL YYYY"))
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = dates[indexPath.section]
        delegate?.monthWasSelected(selectedDate: date)
        self.dismiss(animated: true)
    }
}

// MARK: - Constants
extension MonthSelectionViewController {
    private enum Constants {
        static let tablePadding: CGFloat = 15
    }
}
