//
//  CurrencyTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 03.11.2021.
//  

import Foundation
import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.textColor = Color.textBG
        label.font = label.font.withSize(Constants.cellFontSize)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = Color.controlBG
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubview(currencyLabel)
        setConstraints()
    }
    
    func setConstraints() {
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            currencyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                   constant: Constants.cellPadding),
            currencyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                    constant: -Constants.cellPadding),
            currencyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.cellLabelMinHeight)
        ])
    }
    
    func configure(text: String) {
        currencyLabel.text = text
    }
    
    enum RoundSide {
        case none
        case top
        case bottom
        case all
    }
    
    var roundSide: RoundSide = .none {
        didSet {
            self.contentView.layer.cornerRadius = Constants.cellCornerRadius
            switch roundSide {
                case .none:
                    self.contentView.layer.maskedCorners = []
                case .top:
                    self.contentView.layer.maskedCorners = [
                        .layerMaxXMinYCorner,
                        .layerMinXMinYCorner
                    ]
                case .bottom:
                    self.contentView.layer.maskedCorners = [
                        .layerMaxXMaxYCorner,
                        .layerMinXMaxYCorner
                    ]
                case .all:
                    self.contentView.layer.maskedCorners = [
                        .layerMaxXMinYCorner,
                        .layerMinXMinYCorner,
                        .layerMaxXMaxYCorner,
                        .layerMinXMaxYCorner
                    ]
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = .gray
        } else {
            contentView.backgroundColor = Color.controlBG
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constants
extension CurrencyTableViewCell {
    private enum Constants {
        static let cellCornerRadius: CGFloat = 5
        static let cellFontSize: CGFloat = 20
        static let cellPadding: CGFloat = 15
        static let cellLabelMinHeight: CGFloat = 70
    }
}
