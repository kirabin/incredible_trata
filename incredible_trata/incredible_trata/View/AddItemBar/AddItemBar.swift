//
//  TabBar.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 25.10.2021.
//
// TODO: setup "Created by" to change automatically

import Foundation
import UIKit
import CoreData

// Any Object defines "class-only-protocol", so no structures can conform to it (allows weak)
protocol AddItemBarDelegate: AnyObject {
    
    func addButtonTapped(noteValue: String?, priceValue: String?, completionHandler: () -> Void)
    func categoryButtonTapped()
}

class AddItemBar: UIView {
    weak var delegate: AddItemBarDelegate?
    
    private let addButton: UIButton = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let boldPlus = UIImage(systemName: "plus", withConfiguration: boldConfig)
        let button = RoundImageButton(image: boldPlus, color: Color.addButtonBG)
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func addButtonTapped() {
        delegate?.addButtonTapped(noteValue: noteField.text,
                                  priceValue: priceField.text,
                                  completionHandler: {
            noteField.text = ""
            priceField.text = ""
        })
    }

    private let categoryButton: UIButton = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .heavy)
        let boldHouse = UIImage(systemName: "house", withConfiguration: boldConfig)
        let button = RoundImageButton(image: boldHouse, color: Color.inputBG)

        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        button.tintColor = Color.inputFG
        return button
    }()
    
    @objc
    private func categoryButtonTapped() {
        delegate?.categoryButtonTapped()
    }

    private let noteField: RoundTextField = {
        let field = RoundTextField(BGColor: Color.inputBG)
        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "Заметка",
            attributes: [NSAttributedString.Key.foregroundColor: Color.inputFG]
        )
        return field
    }()

    private let priceField: UITextField = {
        let field = RoundTextField(BGColor: Color.inputBG)
        field.keyboardType = .numberPad
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "\(CoreDataManager.shared.getCurrency()?.symbol ?? "?")0",
            attributes: [NSAttributedString.Key.foregroundColor: Color.inputFG]
        )
        return field
    }()
    
    private let addItemBarStack: UIStackView = {
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

    init() {
        super.init(frame: .zero)
        self.backgroundColor = Color.mainBG
        self.layer.shadowColor = Color.mainBG.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAddItemBarStack() {
        addItemBarStack.addArrangedSubview(categoryButton)
        addItemBarStack.addArrangedSubview(noteField)
        addItemBarStack.addArrangedSubview(priceField)
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
            priceField.widthAnchor.constraint(equalToConstant: Constants.priceFieldWidth)
        ])
    }
}

// MARK: - Constants
extension AddItemBar {
    // TODO: Why use enum for Constants instead of struct? 
    private enum Constants {
        static let barItemHeight: CGFloat = 50.0
        static let priceFieldWidth: CGFloat = 80.0
        static let stackSpacing: CGFloat = 16.0
        static let stackPadding: CGFloat = 15.0
        static let stackCustomSpacing: CGFloat = 2.0
    }
}
