//
//  CategoryAmountDetailViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 09.11.2021.
//  

import Foundation
import UIKit
import Charts

extension Date {
    
    var ommitingTime: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
}

class CategoryAmountDetailViewController: UIViewController {

    private lazy var dates: [Date] = []
    
    private lazy var groupedRecords: [Date: [Record]] = [:] {
        didSet {
            dates = Array(groupedRecords.keys).sorted(by: >)
        }
    }
    
    func groupRecords() {
        groupedRecords = Dictionary.init(grouping: records, by: { $0.creation_date!.ommitingTime })
    }

    private lazy var records: [Record] = [] {
        didSet {
            groupRecords()
        }
    }
    
    init(category: Category, records: [Record]) {
        super.init(nibName: nil, bundle: nil)
        self.title = category.lableName
        self.records = records
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var recordsTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Color.mainBG
        table.backgroundColor = Color.mainBG
        table.register(CategoryAmountDetailTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBG
        
        view.addSubview(recordsTable)
        setConstraints()
    }
    
    func setConstraints() {
        recordsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            recordsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            recordsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        groupRecords()
        recordsTable.reloadData()
    }
}

extension CategoryAmountDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedRecords[dates[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellReuseIdentifier,
            for: indexPath
        ) as! CategoryAmountDetailTableViewCell

        let cellModel = (groupedRecords[dates[indexPath.section]] ?? [])[indexPath.row]
        cell.configure(viewModel: cellModel)
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
        let record = groupedRecords[dates[indexPath.section]]![indexPath.row]
        let settingsRecordViewController = SettingsRecordViewController()
        settingsRecordViewController.reloadRecord(inputRecord: record)
        self.navigationController?.pushViewController(settingsRecordViewController, animated: true)
    }
}

// MARK: - Constants
extension CategoryAmountDetailViewController {
    private enum Constants {
        static let cellReuseIdentifier = "categoryAmountDetailCellID"
    }
}
