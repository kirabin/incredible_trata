//
//  StoriesViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 16.11.2021.
//  

import UIKit

// swiftlint:disable type_body_length
class StoriesViewController: UIViewController {

    // MARK: - Private Properties
    private let currencySymbol: String = CoreDataManager.shared.getUserSelectedCurrencySymbol()

    private let colors: [(start: CGColor, end: CGColor)] = [
        (#colorLiteral(red: 0.9411764706, green: 0.5411764706, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.431372549, blue: 0.3803921569, alpha: 1)),
        (#colorLiteral(red: 0.6156862745, green: 0.4039215686, blue: 0.9647058824, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.4980392157, blue: 0.9647058824, alpha: 1)),
        (#colorLiteral(red: 0.3882352941, green: 0.662745098, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.262745098, green: 0.3411764706, blue: 0.7019607843, alpha: 1))
    ]

    private var categoriesWithAmount: [(category: Category, amount: Int64)] = [] {
        didSet {
            categoriesTable.reloadData()
        }
    }

    private var records: [Record] = []
    private var dateRange: DateRange

    // MARK: - Subviews
    private lazy var gradientLayerOne: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [colors[0].start, colors[0].end]
        return gradient
    }()

    private lazy var gradientLayerTwo: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [colors[1].start, colors[1].end]
        return gradient
    }()

    private lazy var gradientLayerThree: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [colors[2].start, colors[2].end]
        return gradient
    }()

    private lazy var progressBarOne = createProgressBar()
    private lazy var progressBarTwo = createProgressBar()
    private lazy var progressBarThree = createProgressBar()

    private lazy var progressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            progressBarOne, progressBarTwo, progressBarThree
        ])
        stack.spacing = 7

        return stack
    }()

    private lazy var currentWeekView: UIStackView = {
        let stack = createSummaryStackLabel(
            title: "\(getAmount(for: records)) \(currencySymbol)",
            body: dateRange.title
        )
        return stack
    }()

    private lazy var previousWeekView: UIStackView = {
        var previousDateRange = dateRange
        previousDateRange.moveToPreviousRange()
        let previousWeekRecords = CoreDataManager.shared.getRecords(dateInterval: previousDateRange.dateInterval)
        let stack = createSummaryStackLabel(
            title: "\(getAmount(for: previousWeekRecords)) \(currencySymbol)",
            body: "Previous Week"
        )
        return stack
    }()

    private lazy var pageOne: UIView = {
        let view = UIView()
        let title = createTitle(with: "Weekly Tratas")

        view.isHidden = true
        currentWeekView.isHidden = true
        previousWeekView.isHidden = true
        view.addSubview(title)
        view.addSubview(currentWeekView)
        view.addSubview(previousWeekView)
        title.translatesAutoresizingMaskIntoConstraints = false
        currentWeekView.translatesAutoresizingMaskIntoConstraints = false
        previousWeekView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            currentWeekView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30),
            currentWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            previousWeekView.topAnchor.constraint(equalTo: currentWeekView.bottomAnchor, constant: 30),
            previousWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
        return view
    }()

    private lazy var highestSpent: UIStackView = {
        let (lowestAmount, highestAmount) = records.map({$0.amount}).minAndMax(by: >) ?? (0, 0)
        let highestSpent = createSummaryStackLabel(
            title: "\(lowestAmount) \(currencySymbol)",
            body: "Highest Spent"
        )
        return highestSpent
    }()

    private lazy var lowestSpent: UIStackView = {
        let (lowestAmount, highestAmount) = records.map({$0.amount}).minAndMax(by: >) ?? (0, 0)
        let lowestSpent = createSummaryStackLabel(
            title: "\(highestAmount) \(currencySymbol)",
            body: "Lowest Spent"
        )
        return lowestSpent
    }()

    private lazy var pageTwo: UIView = {
        let view = UIView()
        let title = createTitle(with: "Weekly Tratas")

        view.isHidden = true
        highestSpent.isHidden = true
        lowestSpent.isHidden = true
        view.addSubview(title)
        view.addSubview(highestSpent)
        view.addSubview(lowestSpent)
        title.translatesAutoresizingMaskIntoConstraints = false
        highestSpent.translatesAutoresizingMaskIntoConstraints = false
        lowestSpent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            highestSpent.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30),
            highestSpent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            lowestSpent.topAnchor.constraint(equalTo: highestSpent.bottomAnchor, constant: 30),
            lowestSpent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
        return view
    }()

    private lazy var categoriesTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        return table
    }()

    private lazy var pageThree: UIView = {
        let view = UIView()
        let title = createTitle(with: "Top Categories")

        view.isHidden = true
        categoriesTable.isHidden = true
        view.addSubview(title)
        view.addSubview(categoriesTable)
        title.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            categoriesTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            categoriesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()

    // MARK: - Initialization
    init() {
        dateRange = .week(Date())
        super.init(nibName: nil, bundle: nil)
        setData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
    }

    // MARK: - Private Methods
    // TODO: duplicate logic
    private func setData() {
        records = CoreDataManager.shared.getRecords(dateInterval: dateRange.dateInterval)
        let groupedRecords = groupRecords(records)
        var categories: [(category: Category, amount: Int64)] = []
        for (category, records) in groupedRecords {
            categories.append((category, getAmount(for: records)))
        }
        if categories.count < 3 {
            self.categoriesWithAmount = Array(categories.sorted(by: { $0.amount > $1.amount }))
        } else {
            self.categoriesWithAmount = Array(categories.sorted(by: { $0.amount > $1.amount })[0..<3])
        }
    }

    private func getAmount(for records: [Record]) -> Int64 {
        var amount: Int64 = 0
        for record in records {
            amount += record.amount
        }
        return amount
    }

    private func groupRecords(_ records: [Record]) -> [Category: [Record]] {
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
        return groupedRecords
    }

    private func createSummaryStackLabel(title: String, body: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)

        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, bodyLabel
        ])
        stack.axis = .vertical
        return stack
    }

    private func createTitle(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = text
        label.textColor = .white
        return label
    }

    private func createProgressBar() -> UIProgressView {
        let view = UIProgressView()
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        view.progressTintColor = .white
        view.setProgress(0, animated: false)
        view.layer.cornerRadius = Constants.progressBarHeight / 2
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.progressBarWidth),
            view.heightAnchor.constraint(equalToConstant: Constants.progressBarHeight)
        ])
        return view
    }

    private func showViewWithAnimation(view: UIView, completion: (() -> Void)? = nil) {
        UIView.transition(with: view, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            view.isHidden = false
        }, completion: {_ in
            if let completion = completion {
                completion()
            }
        })
    }

    private func showPageOne() {
        showViewWithAnimation(view: pageOne, completion: {
            self.showViewWithAnimation(view: self.currentWeekView, completion: {
                self.showViewWithAnimation(view: self.previousWeekView, completion: nil)
            })
        })
    }

    private func showPageTwo() {
        pageOne.isHidden = true
        view.layer.insertSublayer(gradientLayerTwo, at: 1)
        showViewWithAnimation(view: pageTwo, completion: {
            self.showViewWithAnimation(view: self.highestSpent, completion: {
                self.showViewWithAnimation(view: self.lowestSpent, completion: nil)
            })
        })
    }

    private func showPageThree() {
        pageTwo.isHidden = true
        view.layer.insertSublayer(gradientLayerThree, at: 2)
        showViewWithAnimation(view: pageThree, completion: {
            self.showViewWithAnimation(view: self.categoriesTable, completion: nil)
        })
    }

    private func startAnimation() {
        showPageOne()
        startProgress(progressBar: progressBarOne) {
            self.showPageTwo()
            self.startProgress(progressBar: self.progressBarTwo) {
                self.showPageThree()
                self.startProgress(progressBar: self.progressBarThree) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    private func startProgress(progressBar: UIProgressView, completion: @escaping () -> Void) {
        progressBar.progress = 1
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear, animations: {
            progressBar.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }

    private func setupViews() {
        view.layer.insertSublayer(gradientLayerOne, at: 0)
        view.addSubview(pageOne)
        view.addSubview(pageTwo)
        view.addSubview(pageThree)
        view.addSubview(progressStack)

        pageOne.translatesAutoresizingMaskIntoConstraints = false
        pageTwo.translatesAutoresizingMaskIntoConstraints = false
        pageThree.translatesAutoresizingMaskIntoConstraints = false
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageOne.topAnchor.constraint(equalTo: view.topAnchor),
            pageOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageOne.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageOne.bottomAnchor.constraint(equalTo: progressStack.topAnchor),

            pageTwo.topAnchor.constraint(equalTo: view.topAnchor),
            pageTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTwo.bottomAnchor.constraint(equalTo: progressStack.topAnchor),

            pageThree.topAnchor.constraint(equalTo: view.topAnchor),
            pageThree.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageThree.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageThree.bottomAnchor.constraint(equalTo: progressStack.topAnchor),

            progressStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            progressStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesWithAmount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: StoriesTableViewCell = tableView.regCell(indexPath: indexPath) else {
            return UITableViewCell()
        }
        let (category, amount) = categoriesWithAmount[indexPath.row]
        let amountString = "\(String(amount)) \(currencySymbol)"
        cell.configure(category: category, amount: amountString)
        return cell
    }
}

// MARK: - Constants
extension StoriesViewController {
    private enum Constants {
        static let progressBarHeight: CGFloat = 4
        static let progressBarWidth: CGFloat = 50
    }
}
