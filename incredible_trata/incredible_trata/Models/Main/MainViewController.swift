//
//  MainViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit
import CoreData
import MapKit

// TODO: rows in sections are sorted in reverse order
class MainViewController: UIViewController {

    // MARK: - Properties
    private lazy var dates: [Date] = []

    private lazy var groupedRecords: [Date: [Record]] = [:] {
        didSet {
            dates = Array(groupedRecords.keys).sorted(by: >)
        }
    }

    private lazy var records: [Record] = [] {
        didSet {
            recordsUpdated()
        }
    }

    private var dateRange: DateRange {
        didSet {
            dateRangeChanged()
        }
    }

    var selectedСategory: Category? {
        didSet {
            addItemBar.setCategoryButtonIcon(imageName: selectedСategory?.imageName ?? "")
        }
    }

    let locationManager = CLLocationManager()

    // MARK: - Subviews
    private lazy var addItemBarBottomConstraint: NSLayoutConstraint = {
        addItemBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()

    private lazy var addItemBar: AddItemBar = {
        let bar = AddItemBar()
        bar.delegate = self
        return bar
    }()

    private lazy var monthSelectionButton: UIButton = {
        let image = UIImage(systemName: "chevron.down.circle.fill")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = Color.textBG
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = button.titleLabel?.font.withSize(23)
        button.setTitleColor(Color.textBG, for: .normal)
        button.addTarget(self, action: #selector(monthSelectionButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.headerButtonHeight)
        ])
        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = RoundButton(with: UIImage(systemName: "gearshape"), size: Constants.headerButtonHeight)
        button.backgroundColor = Color.headerButtonBG
        button.tintColor = Color.textBG
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var graphButton: UIButton = {
        let button = RoundButton(with: UIImage(systemName: "doc.plaintext"), size: Constants.headerButtonHeight)
        button.backgroundColor = Color.headerButtonBG
        button.tintColor = Color.textBG
        button.addTarget(self, action: #selector(graphButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var storiesButton: UIButton = {
        let button = RoundButton(with: UIImage(systemName: "dollarsign.circle.fill"),
                                 size: Constants.headerButtonHeight)
        button.backgroundColor = Color.headerButtonBG
        button.tintColor = Color.textBG
        button.addTarget(self, action: #selector(storiesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            monthSelectionButton, storiesButton, graphButton, settingsButton
        ])
        monthSelectionButton.contentHorizontalAlignment = .left
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 15,
            leading: 15,
            bottom: 15,
            trailing: 15
        )
        stack.distribution = .fill
        stack.spacing = 7
        return stack
    }()

    private lazy var customTableView: UITableView = {
        let customTableView = UITableView()
        customTableView.delegate = self
        customTableView.dataSource = self
        customTableView.translatesAutoresizingMaskIntoConstraints = false
        customTableView.backgroundColor = Color.mainBG
        return customTableView
    }()

    // MARK: - Initialization
    init() {
        dateRange = .month(CoreDataManager.shared.getLastRecordDate() ?? Date())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBG
        navigationItem.backButtonTitle = ""
        view.addSubview(customTableView)
        view.addSubview(addItemBar)
        view.addSubview(headerStackView)
        setConstraints()
        setCategory()
        setNotificationCenter()
        dateRangeChanged()
        CurrencyNetworkManager.shared.obtainCurrency()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func dateRangeChanged() {
        updateRecords()
        monthSelectionButton.setTitle(dateRange.dateInterval.start.convert(to: "LLLL YYYY"), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        updateRecords()
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        addItemBar.updateAmountField()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Private Methods
    @objc
    private func storiesButtonTapped() {
        self.present(StoriesViewController(), animated: true)
    }

    @objc
    private func graphButtonTapped() {
        let graphViewController = GraphViewController(dateRange: dateRange)
        self.navigationController?.pushViewController(graphViewController, animated: true)
    }

    @objc
    private func settingsButtonTapped() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    @objc
    private func monthSelectionButtonTapped() {
        let monthSelectionViewController = MonthSelectionViewController()
        monthSelectionViewController.delegate = self
        navigationController?.present(monthSelectionViewController, animated: true, completion: nil)
    }

    private func setConstraints() {
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addItemBarBottomConstraint,
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            customTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0),
            customTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            customTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0),
            customTableView.bottomAnchor.constraint(equalTo: addItemBar.topAnchor, constant: 0)
        ])
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue {
            addItemBarBottomConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()  // Updates layout with animation if needed
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        addItemBarBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

    private func setCategory() {
        let categories = CoreDataManager.shared.getCategories()

        if categories.isEmpty {
            // TODO: fatal?
        } else {
            selectedСategory = categories[0]
        }
    }

    private func updateRecords() {
        records = CoreDataManager.shared.getRecords(dateInterval: dateRange.dateInterval)
        if records.isEmpty {
            if let lastRecordDate = CoreDataManager.shared.getLastRecordDate() {
                dateRange = .month(lastRecordDate)
            }
        }
    }

    private func recordsUpdated() {
        groupedRecords = Dictionary.init(grouping: records, by: {
            $0.creationDate?.trimTo(components: .year, .month, .day) ?? Date()
        })
        customTableView.reloadData()
    }
}

// MARK: - CategoriesViewControllerDelegate
extension MainViewController: CategoriesViewControllerDelegate {
    func categoryWasSelected(category: Category) {
        selectedСategory = category
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {

}

// MARK: - AddItemBarDelegate
extension MainViewController: AddItemBarDelegate {
    func addButtonTapped(noteValue: String?, priceValue: String?, completionHandler: () -> Void) {
        guard let noteValue = noteValue,
              let priceValue = priceValue,
              let amount = Int64(priceValue),
              amount != 0,
              let selectedCurrency = CoreDataManager.shared.getUserSettings()?.currency,
              let selectedСategory = selectedСategory
        else {
            return
        }
        do {
            try CoreDataManager.shared.saveRecord(
                note: noteValue,
                amount: amount,
                currency: selectedCurrency,
                category: selectedСategory,
                longitude: (locationManager.location?.coordinate)?.longitude ?? 0,
                latitude: (locationManager.location?.coordinate)?.latitude ?? 0
            )
            completionHandler()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        dateRange = .month(Date())
        updateRecords()
        view.endEditing(true)
    }

    func categoryButtonTapped() {
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.delegate = self

        let navVC = UINavigationController(rootViewController: categoriesViewController)
        navVC.navigationBar.barTintColor = .none
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.present(navVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedRecords[dates[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RecordTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }

        let cellModel = (groupedRecords[dates[indexPath.section]] ?? [])[indexPath.row]
        cell.setRoundSide(tableView: tableView, indexPath: indexPath)
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

        // TODO: convert to other currencies, CurrencyConverter?
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

// MARK: - MonthSelectionViewControllerDelegate
extension MainViewController: MonthSelectionViewControllerDelegate {
    func monthWasSelected(selectedDate: Date) {
        dateRange = .month(selectedDate)
    }
}

// MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let headerButtonHeight: CGFloat = 45
    }
}
