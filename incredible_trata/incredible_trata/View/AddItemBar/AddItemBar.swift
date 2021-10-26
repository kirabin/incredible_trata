//
//  TabBar.swift
//  incredible_trata
//
//  Created by Рябин Кирилл on 25.10.2021.
//

import Foundation
import UIKit

// TODO: setup "Created by" to change automatically
class AddItemBar: UIView {
    private let addButton: UIButton = {
        let button = RoundImageButton(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: Constants.AddButton.BGColor)
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let typeButton: UIButton = {
        let button = RoundImageButton(image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: Constants.darkGreyBGColor)
        button.tintColor = Constants.greyTextColor
        return button
    }()
    
    private let noteField: RoundTextField = {
        let field = RoundTextField(BGColor: Constants.darkGreyBGColor)
        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "Заметка",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.greyTextColor]
        )
        return field
    }()
    
    private let priceField: UITextField = {
        let field = RoundTextField(BGColor: Constants.darkGreyBGColor)
        field.keyboardType = .numberPad
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "$0",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.greyTextColor]
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
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: Constants.stackPadding, leading: Constants.stackPadding, bottom: Constants.stackPadding, trailing: Constants.stackPadding)
        return stack
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = Constants.backgroundColor
        self.layer.shadowColor = backgroundColor?.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func addButtonAction() {
        // TODO: button action
        print("1")
    }

    private func setupAddItemBarStack() {
        addItemBarStack.addArrangedSubview(typeButton)
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

            typeButton.widthAnchor.constraint(equalToConstant: Constants.barItemHeight),

            priceField.widthAnchor.constraint(equalToConstant: Constants.priceFieldWidth)
        ])
    }
}

// TODO: Move colors to assets
// MARK: - Constants
extension AddItemBar {
    // TODO: Why use enum for Constants instead of struct? 
    private enum Constants {
        static let darkGreyBGColor = UIColor(red: 48 / 255.0, green: 48 / 255.0, blue: 50 / 255.0, alpha: 1.0)
        static let greyTextColor = UIColor(red: 196 / 255.0, green: 196 / 255.0, blue: 196 / 255.0, alpha: 1.0)
        static let backgroundColor = UIColor(red: 17.0 / 255.0, green: 17.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
        static let barItemHeight: CGFloat = 50.0
        static let priceFieldWidth: CGFloat = 80.0
        static let stackSpacing: CGFloat = 16.0
        static let stackPadding: CGFloat = 15.0
        static let stackCustomSpacing: CGFloat = 2.0

        enum AddButton {
            static let BGColor = UIColor(red: 211.0 / 255.0, green: 74.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
        }
    }
}
