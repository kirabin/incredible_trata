//
//  CategoryAmountDetailViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 09.11.2021.
//

import UIKit
import Charts

class CategoryAmountDetailViewController: UIViewController {

    // MARK: - Private Properties
    private lazy var dates: [Date] = []

    private lazy var groupedRecords: [Date: [Record]] = [:] {
        didSet {
            dates = Array(groupedRecords.keys).sorted(by: >)
        }
    }

    private lazy var records: [Record] = [] {
        didSet {
            groupRecords()
        }
    }

    // MARK: - Subviews
    private lazy var recordsTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Color.mainBG
        table.backgroundColor = Color.mainBG
        return table
    }()

    // MARK: - Initialization
    init(category: Category, records: [Record]) {
        super.init(nibName: nil, bundle: nil)
        self.title = category.lableName
        self.records = records
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBG
        view.addSubview(recordsTable)
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        groupRecords()
        recordsTable.reloadData()
    }

    // MARK: - Private Methods
    private func groupRecords() {
        groupedRecords = Dictionary.init(grouping: records, by: {
            $0.creationDate?.trimTo(components: .year, .month, .day) ?? Date()
        })
    }

    private func setConstraints() {
        recordsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            recordsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            recordsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoryAmountDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedRecords[dates[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryAmountDetailTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }

        let cellModel = (groupedRecords[dates[indexPath.section]] ?? [])[indexPath.row]
        cell.configure(record: cellModel)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = UILabel()
        let amount = UILabel()
        let stack = UIStackView(arrangedSubviews: [date, amount])
        stack.backgroundColor = Color.mainBG.withAlphaComponent(0.9)
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins =
        NSDirectionalEdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12)
        date.text = dates[section].formatted(date: .abbreviated, time: .omitted)
        date.textColor = .lightGray
        // TODO: convert to other currencies
        var sum: Int64 = 0
        for record in groupedRecords[dates[section]] ?? [] {
            sum += record.amount
        }
        amount.text = "\(CoreDataManager.shared.getUserSelectedCurrencySymbol())\(sum)"
        amount.textColor = .lightGray
        return stack
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let record = groupedRecords[dates[indexPath.section]]?[indexPath.row] else {return}
        let settingsRecordViewController = SettingsRecordViewController()
        settingsRecordViewController.reloadRecord(inputRecord: record)
        self.navigationController?.pushViewController(settingsRecordViewController, animated: true)
    }
}
