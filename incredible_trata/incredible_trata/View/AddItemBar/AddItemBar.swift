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
        let button = RoundImageButton(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: UIColor(named: "addButtonBG") ?? .red)
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let typeButton: UIButton = {
        let button = RoundImageButton(image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: UIColor(named: "inputBG") ?? .red)
        button.tintColor = UIColor(named: "inputFG") ?? .red
        return button
    }()
    
    private let noteField: RoundTextField = {
        let field = RoundTextField(BGColor: UIColor(named: "inputBG") ?? .red)
        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "Заметка",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "inputFG") ?? .red]
        )
        return field
    }()

    private let priceField: UITextField = {
        let field = RoundTextField(BGColor: UIColor(named: "inputBG") ?? .red)
        field.keyboardType = .numberPad
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        field.attributedPlaceholder = NSAttributedString(
            string: "$0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "inputFG") ?? .red]
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
        self.backgroundColor = UIColor(named: "mainBG") ?? .red
        self.layer.shadowColor = UIColor(named: "mainBG")?.cgColor
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
        static let barItemHeight: CGFloat = 50.0
        static let priceFieldWidth: CGFloat = 80.0
        static let stackSpacing: CGFloat = 16.0
        static let stackPadding: CGFloat = 15.0
        static let stackCustomSpacing: CGFloat = 2.0

    }
}
