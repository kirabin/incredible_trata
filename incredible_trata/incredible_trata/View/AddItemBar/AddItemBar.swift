//
//  TabBar.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 25.10.2021.
//

import Foundation
import UIKit

protocol AddItemBarDelegate: AnyObject {
    func addButtonTapped(noteValue: String?, priceValue: String?, completionHandler: () -> Void)
    func categoryButtonTapped()
}

class AddItemBar: UIView {

    // MARK: - Public Properties
    weak var delegate: AddItemBarDelegate?

    // MARK: - Subviews
    private lazy var addButton: UIButton = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let boldPlusImage = UIImage(systemName: "plus", withConfiguration: boldConfig)
        let button = RoundButton(with: boldPlusImage)
        button.backgroundColor = Color.addButtonBG
        button.tintColor = Color.textBG
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var categoryButton: UIButton = {

        let button = RoundButton()
        button.backgroundColor = Color.controlBG
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        button.tintColor = Color.inputFG
        return button
    }()

    private lazy var noteField: UITextField = {
        let field = AddItemBarTextField()
        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        field.placeholder = Constants.noteFieldPlaceholderText
        return field
    }()

    private lazy var amountField: UITextField = {
        let field = AddItemBarTextField()
        field.keyboardType = .numberPad
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        field.placeholder = "\(CoreDataManager.shared.getUserSelectedCurrencySymbol())0"
        return field
    }()

    private lazy var addItemBarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Constants.stackSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.stackPadding,
                                                                 leading: Constants.stackPadding,
                                                                 bottom: Constants.stackPadding,
                                                                 trailing: Constants.stackPadding)
        return stack
    }()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func updateAmountField() {
        amountField.placeholder = "\(CoreDataManager.shared.getUserSelectedCurrencySymbol())0"
    }

    func setCategoryButtonIcon(imageName: String) {
        let boldConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let boldImage = UIImage(systemName: imageName, withConfiguration: boldConfig)
        categoryButton.setImage(boldImage, for: .normal)
    }

    // MARK: - Private Methods
    @objc
    private func addButtonTapped() {
        delegate?.addButtonTapped(noteValue: noteField.text,
                                  priceValue: amountField.text,
                                  completionHandler: {
            noteField.text = ""
            amountField.text = ""
        })
    }

    @objc
    private func categoryButtonTapped() {
        delegate?.categoryButtonTapped()
    }

    private func setupAddItemBarStack() {
        addItemBarStack.addArrangedSubview(categoryButton)
        addItemBarStack.addArrangedSubview(noteField)
        addItemBarStack.addArrangedSubview(amountField)
        addItemBarStack.addArrangedSubview(addButton)
        addItemBarStack.setCustomSpacing(Constants.stackCustomSpacing, after: noteField)
    }

    private func setupSubViews() {
        setupAddItemBarStack()
        addSubview(addItemBarStack)
        setConstraints()
    }

    private func setConstraints() {
        addItemBarStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addItemBarStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            addItemBarStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            addItemBarStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            addItemBarStack.topAnchor.constraint(equalTo: topAnchor),
            addButton.widthAnchor.constraint(equalToConstant: Constants.barItemHeight),
            categoryButton.widthAnchor.constraint(equalToConstant: Constants.barItemHeight),
            amountField.widthAnchor.constraint(equalToConstant: Constants.priceFieldWidth)
        ])
    }
}

// MARK: - Constants
extension AddItemBar {
    private enum Constants {
        static let barItemHeight: CGFloat = 50.0
        static let priceFieldWidth: CGFloat = 80.0
        static let stackSpacing: CGFloat = 16.0
        static let stackPadding: CGFloat = 15.0
        static let stackCustomSpacing: CGFloat = 2.0
        static let noteFieldPlaceholderText = "Note"
    }
}
