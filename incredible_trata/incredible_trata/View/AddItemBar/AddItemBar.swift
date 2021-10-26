//
//  TabBar.swift
//  incredible_trata
//
//  Created by a19658227 on 25.10.2021.
//

import Foundation
import UIKit


class AddItemBar: UIView {
    var addButton: UIButton!
    var typeButton: UIButton!
    var noteField: UITextField!
    var priceField: UITextField!
    var addItemBarStack: UIStackView!

    private let addButtonBGColor = UIColor(red: 211.0 / 255.0, green: 74.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    private let darkGreyBGColor = UIColor(red: 48 / 255.0, green: 48 / 255.0, blue: 50 / 255.0, alpha: 1.0)
    private let greyTextColor = UIColor(red: 196 / 255.0, green: 196 / 255.0, blue: 196 / 255.0, alpha: 1.0)
    
    private let buttonHeight: CGFloat = 50
  
    init() {
        super.init(frame: .zero)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func addButtonAction() {
        print("1")
    }
    
    func createSubViews() {
        addButton = RoundImageButton(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: addButtonBGColor)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        noteField = RoundTextField(BGColor: darkGreyBGColor)
        noteField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        noteField.attributedPlaceholder = NSAttributedString(
            string: "Заметка",
            attributes: [NSAttributedString.Key.foregroundColor: greyTextColor]
        )
        
        priceField = RoundTextField(BGColor: darkGreyBGColor)
        priceField.keyboardType = .numberPad
        priceField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        priceField.attributedPlaceholder = NSAttributedString(
            string: "$0",
            attributes: [NSAttributedString.Key.foregroundColor: greyTextColor]
        )
        
        typeButton = RoundImageButton(image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), color: darkGreyBGColor)
        typeButton.tintColor = greyTextColor

        addItemBarStack = UIStackView()
        addItemBarStack.axis = .horizontal
        addItemBarStack.distribution = .fill
        addItemBarStack.alignment = .fill
        addItemBarStack.spacing = 16.0
        
        addItemBarStack.addArrangedSubview(typeButton)
        addItemBarStack.addArrangedSubview(noteField)
        addItemBarStack.addArrangedSubview(priceField)
        addItemBarStack.addArrangedSubview(addButton)

        addItemBarStack.setCustomSpacing(2, after: noteField)
        addSubview(addItemBarStack)
        setConstraints()
    }

    func setConstraints() {
        addItemBarStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addItemBarStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            addItemBarStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            addItemBarStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            addItemBarStack.topAnchor.constraint(equalTo: topAnchor)
        ])
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: buttonHeight),
        ])
        NSLayoutConstraint.activate([
            typeButton.widthAnchor.constraint(equalToConstant: buttonHeight),
        ])
        NSLayoutConstraint.activate([
            priceField.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
