//
//  GraphViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 08.11.2021.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    // MARK: - Private Properties
    private let colors: [UIColor] = [.orange, .yellow, .green, .blue, .cyan, .magenta]

    private var dateRange: DateRange {
        didSet {
            dateRangeChanged()
        }
    }

    private lazy var categoriesWithAmount: [(category: Category, amount: Int64)] = [] {
        didSet {
            categorySummary.reloadData()
        }
    }

    private lazy var groupedRecords: [Category: [Record]] = [:] {
        didSet {
            var categories: [(category: Category, amount: Int64)] = []
            for (category, records) in groupedRecords {
                categories.append((category, getAmount(for: records)))
            }
            self.categoriesWithAmount = categories.sorted(by: { $0.amount > $1.amount })
        }
    }

    private lazy var records: [Record] = [] {
        didSet {
            recordsChanged()
        }
    }

    private var style: ChartStyle = .bar {
        didSet {
            switch style {
            case .bar:
                chartView.isHidden = false
                changeChartButton.image = UIImage(systemName: "chart.bar.xaxis")
                pieChartView.isHidden = true
            case .pie:
                chartView.isHidden = true
                changeChartButton.image = UIImage(systemName: "chart.pie.fill")
                pieChartView.isHidden = false
            }
        }
    }

    // MARK: - Subviews
    private lazy var dateButton: UIBarButtonItem = {
        let image = UIImage(systemName: "calendar")
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(dateButtonWasTapped))
        return button
    }()

    private lazy var changeChartButton: UIBarButtonItem = {
        let image = UIImage(systemName: "chart.bar.xaxis")
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(changeChartButtonAction))
        return button
    }()

    private lazy var summaryLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(40)
        return label
    }()

    private lazy var chartView: BarChartView = {
        var view = BarChartView()
        view.noDataTextColor = .white
        view.leftAxis.labelTextColor = .white
        view.leftAxis.drawAxisLineEnabled = false
        view.rightAxis.enabled = false
        view.xAxis.enabled = false
        view.legend.enabled = false
        return view
    }()

    private lazy var pieChartView: PieChartView = {
        var view = PieChartView()
        view.noDataTextColor = .white
        view.holeRadiusPercent = 0.0
        view.transparentCircleRadiusPercent = 0.0
        view.legend.enabled = false
        view.isHidden = true
        return view
    }()

    private lazy var categorySummary: UITableView = {
        var view = UITableView()
        view.backgroundColor = Color.mainBG
        view.separatorColor = Color.mainBG
        view.delegate = self
        view.dataSource = self
        return view
    }()

    // MARK: - Initialization
    init(dateRange: DateRange) {
        self.dateRange = dateRange
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        navigationItem.rightBarButtonItems = [dateButton, changeChartButton]
        view.backgroundColor = Color.mainBG
        view.addSubview(summaryLabel)
        view.addSubview(chartView)
        view.addSubview(categorySummary)
        view.addSubview(pieChartView)
        setConstrainst()
        dateRangeChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: try updating just one (changed date, or amount)
        updateRecords()
        categorySummary.reloadData()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private Methods
    private func dateRangeChanged() {
        updateRecords()
    }

    private func recordsChanged() {
        groupRecords()
        updateCharts()
        updatePieCharts()
        title = dateRange.title
        summaryLabel.text = "\(CoreDataManager.shared.getUserSelectedCurrencySymbol())\(getAmount(for: records))"
    }

    private func groupRecords() {
        // TODO: force unwrap
        var groupedRecords = Dictionary.init(grouping: records, by: { $0.category! })
        for (category, records) in groupedRecords {
            var category = category
            while let parentCategory = category.parentCategory {
                groupedRecords[category] = nil
                if groupedRecords[parentCategory] != nil {
                    groupedRecords[parentCategory]?.append(contentsOf: records)
                } else {
                    groupedRecords[parentCategory] = records
                }
                category = parentCategory
            }
        }
        self.groupedRecords = groupedRecords
    }

    private func updateRecords() {
        records = CoreDataManager.shared.getRecords(dateInterval: dateRange.dateInterval)
    }

    private func getAmount(for records: [Record]) -> Int64 {
        var amount: Int64 = 0
        for record in records {
            amount += record.amount
        }
        return amount
    }

    @objc
    private func dateButtonWasTapped() {
        let calendarViewController = CalendarViewController(
            delegate: self,
            dateRange: dateRange
        )
        self.present(calendarViewController, animated: true)
    }

    @objc
    private func changeChartButtonAction() {
        if style == .bar {
            style = .pie
        } else {
            style = .bar
        }
    }

    private func setConstrainst() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        categorySummary.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                              constant: Constants.padding),
            summaryLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                  constant: Constants.padding),
            chartView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: Constants.padding),
            chartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                constant: -Constants.padding),
            chartView.heightAnchor.constraint(equalToConstant: 300),
            categorySummary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                     constant: Constants.padding),
            categorySummary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                      constant: -Constants.padding),
            categorySummary.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            categorySummary.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pieChartView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                  constant: Constants.padding),
            pieChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                   constant: -Constants.padding),
            pieChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GraphViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesWithAmount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GraphTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }

        let (category, amount) = categoriesWithAmount[indexPath.row]

        let iconColor = colors[indexPath.row % colors.count]

        cell.setRoundSide(tableView: tableView, indexPath: indexPath)
        cell.configure(category: category, amount: amount, iconColor: iconColor)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesWithAmount[indexPath.row].category
        let detailView = CategoryAmountDetailViewController(
            category: category,
            records: groupedRecords[category] ?? []
        )
        navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: - CalendarViewControllerDelegate
extension GraphViewController: CalendarViewControllerDelegate {
    func updateDateRange(for dateRange: DateRange) {
        self.dateRange = dateRange
    }
}

// MARK: - ChartViewDelegate, AxisValueFormatter
extension GraphViewController: ChartViewDelegate, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        "\(Int(value))"
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }

    func updateCharts() {
        var chartDataEntries: [BarChartDataEntry] = []
        var chartBarDataEntries: [BarChartDataEntry] = []
        var number = 0
        for (category, amount) in categoriesWithAmount {
            chartDataEntries.append(BarChartDataEntry(x: Double(number), y: Double(amount)))
            chartBarDataEntries.append(BarChartDataEntry(x: 0, y: 0, data: category.lableName))
            number += 1
        }
        let dataSet = BarChartDataSet(entries: chartDataEntries)
        // TODO: change colors
        dataSet.setColors(.orange, .yellow, .green, .blue, .cyan, .magenta)
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = Double(0.50)
        chartView.data = data
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = self
    }

    func updatePieCharts() {
        var pieChartDataEntries: [PieChartDataEntry] = []
        for (_, amount) in categoriesWithAmount {
            pieChartDataEntries.append(PieChartDataEntry(value: Double(amount)))
        }
        let dataSet = PieChartDataSet(entries: pieChartDataEntries)
        dataSet.drawValuesEnabled = false
        dataSet.setColors(.orange, .yellow, .green, .blue, .cyan, .magenta)
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
}

// MARK: - ChartStyle
extension GraphViewController {
    enum ChartStyle {
        case bar
        case pie
    }
}

// MARK: - Constants
extension GraphViewController {
    private enum Constants {
        static let cellReuseIdentifier = "graphCell"
        static let padding: CGFloat = 15
    }
}
