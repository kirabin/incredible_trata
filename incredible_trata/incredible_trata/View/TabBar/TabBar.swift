//
//  TabBar.swift
//  incredible_trata
//
//  Created by a19658227 on 25.10.2021.
//

import Foundation
import UIKit

class TabBar: UIView {
    var addButton: UIButton!
    var typeButton: UIButton!
    var noteButton: UIButton!
    var priceButton: UIButton!
    var splitButtonStack: UIStackView!
    var tabStack: UIStackView!

    private let addButtonBGColor = UIColor(red: 211.0 / 255.0, green: 74.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    private let darkGreyColor = UIColor(red: 48 / 255.0, green: 48 / 255.0, blue: 50 / 255.0, alpha: 1.0)
    private let greyTextColor = UIColor(red: 196 / 255.0, green: 196 / 255.0, blue: 196 / 255.0, alpha: 1.0)
    
    private let buttonHeight: CGFloat = 50
  
    init() {
        super.init(frame: .zero)
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
  
        addButton = RoundImageButton(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), height: buttonHeight, color: addButtonBGColor)
        
        noteButton = UIButton(type: .system)
        noteButton.setTitle("Заметка", for: .normal)
        noteButton.backgroundColor = darkGreyColor
        noteButton.layer.cornerRadius = buttonHeight / 2
        noteButton.tintColor = greyTextColor
        noteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        noteButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        priceButton = UIButton(type: .system)
        priceButton.setTitle("$\(0)", for: .normal)
        priceButton.backgroundColor = darkGreyColor
        priceButton.layer.cornerRadius = buttonHeight / 2
        priceButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        priceButton.tintColor = greyTextColor
        priceButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        splitButtonStack = UIStackView()
        splitButtonStack.axis = NSLayoutConstraint.Axis.horizontal
        splitButtonStack.distribution = UIStackView.Distribution.fill
        splitButtonStack.spacing = 2.0
        splitButtonStack.layer.cornerRadius = buttonHeight / 2
        splitButtonStack.addArrangedSubview(noteButton)
        splitButtonStack.addArrangedSubview(priceButton)

        typeButton = RoundImageButton(image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), height: buttonHeight, color: darkGreyColor)
        typeButton.tintColor = greyTextColor

        tabStack = UIStackView()
        tabStack.axis = NSLayoutConstraint.Axis.horizontal
        tabStack.distribution = UIStackView.Distribution.fill
        tabStack.alignment = UIStackView.Alignment.fill  // questionable decision
        tabStack.spacing = 16.0
        
        tabStack.addArrangedSubview(typeButton)
        tabStack.addArrangedSubview(splitButtonStack)
        tabStack.addArrangedSubview(addButton)
        
        addSubview(tabStack)
        setConstraints()
    }
    
    func setConstraints() {
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabStack.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            addButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        typeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            typeButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
