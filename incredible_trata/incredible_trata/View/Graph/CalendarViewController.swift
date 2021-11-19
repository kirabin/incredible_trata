//
//  CalendarViewController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 08.11.2021.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func updateDateRange(for dateRange: DateRange)
}

// swiftlint:disable type_body_length
class CalendarViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: CalendarViewControllerDelegate?

    // MARK: - Private Properties
    private var dateRange: DateRange {
        didSet {
            dateRangeUpdated()
            updateDatePickers()
        }
    }

    // MARK: - Types
    private enum Direction {
        case leftToRight, rightToLeft

        var multiplier: Int {
            switch self {
            case .leftToRight:
                return -1
            case .rightToLeft:
                return 1
            }
        }
    }

    // MARK: - Subviews
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
        button.addTarget(
            self,
            action: #selector(doneBarButtonItemWasTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var beginDate: UIStackView = {
        let label = createLabel(with: "Begin", of: 20)
        let stack = UIStackView(arrangedSubviews: [label, beginDatePicker])
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Constants.padding,
            leading: Constants.padding * 2,
            bottom: Constants.padding,
            trailing: Constants.padding * 2
        )
        return stack

    }()

    private lazy var endDate: UIStackView = {
        let label = createLabel(with: "End", of: 20)
        let stack = UIStackView(arrangedSubviews: [label, endDatePicker])
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Constants.padding,
            leading: Constants.padding * 2,
            bottom: Constants.padding,
            trailing: Constants.padding * 2
        )
        return stack
    }()

    private lazy var weekButton = createRangeButton(with: "Week", action: weekButtonTapped)
    private lazy var monthButton = createRangeButton(with: "Month", action: monthButtonTapped)
    private lazy var yearButton = createRangeButton(with: "Year", action: yearButtonTapped)

    private lazy var weekMonthYear: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIView(), weekButton, monthButton, yearButton, UIView()
        ])
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()

    private lazy var beginDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)),
                             for: .valueChanged)
        return datePicker
    }()

    private lazy var endDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)),
                             for: .valueChanged)
        return datePicker
    }()

    private lazy var rangeLabel: UILabel = {
        let label = createLabel(with: "", of: 24)
        return label
    }()

    private lazy var rangeLabelView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addSubview(rangeLabel)
        rangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 40),
            rangeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rangeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()

    private lazy var prevButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
        return button
    }()

    private lazy var prevNextView: UIView = {
        let stack = UIStackView(arrangedSubviews: [
            prevButton, rangeLabelView, nextButton
        ])
        stack.distribution = .fill
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Constants.padding * 2,
            leading: Constants.padding * 2,
            bottom: Constants.padding,
            trailing: Constants.padding * 2
        )
        return stack
    }()

    // MARK: - Initialization
    init(delegate: CalendarViewControllerDelegate, dateRange: DateRange) {
        self.delegate = delegate
        self.dateRange = dateRange
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [ .medium() ]
        }
        view.backgroundColor = Color.mainBG
        view.addSubview(doneButton)
        view.addSubview(weekMonthYear)
        view.addSubview(prevNextView)
        view.addSubview(beginDate)
        view.addSubview(endDate)
        setConstraints()
        dateRangeUpdated()
    }

    // MARK: - Private Methods
    private func updateDatePickers() {
        beginDatePicker.date = dateRange.dateInterval.start
        endDatePicker.date = dateRange.dateInterval.end
    }

    private func dateRangeUpdated() {
        weekButton.isSelected = false
        monthButton.isSelected = false
        yearButton.isSelected = false
        prevButton.isHidden = false
        nextButton.isHidden = false
        rangeLabel.textColor = .white
        updateRangeLabel()
        updateDatePickers()

        switch dateRange {
        case .week:
            weekButton.isSelected = true
        case .month:
            monthButton.isSelected = true
        case .year:
            yearButton.isSelected = true
        case .custom:
            prevButton.isHidden = true
            nextButton.isHidden = true
            rangeLabel.textColor = .orange
        }
    }

    @objc
    private func doneBarButtonItemWasTapped() {
        self.dismiss(animated: true)
        delegate?.updateDateRange(for: dateRange)
    }

    private func createRangeButton(with title: String, action: @escaping () -> Void) -> UIButton {
        let button = ActionButton(with: action)
        button.backgroundColor = Color.controlBG
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.orange, for: .selected)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 80)
        ])
        return button
    }

    @objc
    private func weekButtonTapped() {
        dateRange = .week(Date())
    }

    @objc
    private func monthButtonTapped() {
        dateRange = .month(Date())
    }

    @objc
    private func yearButtonTapped() {
        dateRange = .year(Date())
    }

    @objc
    func prevButtonTapped() {
        updateRangeLabelWithAnimation(direction: .leftToRight) {
            self.dateRange.moveToPreviousRange()
        }
    }

    @objc
    private func nextButtonTapped() {
        updateRangeLabelWithAnimation(direction: .rightToLeft) {
            self.dateRange.moveToNextRange()
        }
    }

    private func updateRangeLabel() {
        rangeLabel.text = dateRange.labelText
    }

    private func updateRangeLabelWithAnimation(direction: Direction, completion: @escaping () -> Void) {
        let offset = CGFloat(300 * direction.multiplier)

        UIView.transition(with: rangeLabel, duration: 0.20, options: .curveEaseInOut, animations: {
            let originX = self.rangeLabel.bounds.origin.x
            let originY = self.rangeLabel.bounds.origin.y
            self.rangeLabel.transform = CGAffineTransform(translationX: originX - offset, y: originY)

        }, completion: {_ in
            let originX = self.rangeLabel.bounds.origin.x
            let originY = self.rangeLabel.bounds.origin.y
            self.rangeLabel.transform = CGAffineTransform(translationX: originX + offset, y: originY)
            completion()

            UIView.transition(with: self.rangeLabel, duration: 0.20, options: .curveEaseInOut, animations: {
                self.rangeLabel.transform = .identity
            })
        })
    }

    @objc
    private func datePickerChanged(_ sender: UIDatePicker) {
        if sender == beginDatePicker, sender.date > dateRange.dateInterval.end {
            sender.date = dateRange.dateInterval.end
        }
        if sender == endDatePicker, sender.date < dateRange.dateInterval.start {
            sender.date = dateRange.dateInterval.start
        }
        dateRange = .custom(DateInterval(start: beginDatePicker.date, end: endDatePicker.date))
        prevButton.isHidden = true
        nextButton.isHidden = true
    }

    private func createLabel(with text: String, of size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = label.font.withSize(size)
        return label
    }

    private func setConstraints() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        weekMonthYear.translatesAutoresizingMaskIntoConstraints = false
        prevNextView.translatesAutoresizingMaskIntoConstraints = false
        beginDate.translatesAutoresizingMaskIntoConstraints = false
        endDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: Constants.padding),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -Constants.padding),

            weekMonthYear.topAnchor.constraint(equalTo: doneButton.bottomAnchor,
                                               constant: Constants.padding),
            weekMonthYear.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weekMonthYear.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            prevNextView.topAnchor.constraint(equalTo: weekMonthYear.bottomAnchor),
            prevNextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            prevNextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            beginDate.topAnchor.constraint(equalTo: prevNextView.bottomAnchor),
            beginDate.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            beginDate.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            endDate.topAnchor.constraint(equalTo: beginDate.bottomAnchor),
            endDate.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endDate.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: - Constants
extension CalendarViewController {
    private enum Constants {
        static let navigationTitle = "Choose Date"
        static let padding: CGFloat = 15
        static let labelPadding: CGFloat = 10
    }
}
