//
//  GraphTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 08.11.2021.
//  

import Foundation
import UIKit

class GraphTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.controlBG
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: Category! {
        didSet {
            categoryName.text = viewModel.lableName
            roundIcon.imageName = viewModel.imageName
        }
    }
    
    private var amount: Int64 = 0 {
        didSet {
            categoryAmount.text = "\(CoreDataManager.shared.getUserSelectedCurrencySymbol())\(amount)"
        }
    }
    
    func configure(viewModel: Category, amount: Int64, iconColor: UIColor) {
        self.viewModel = viewModel
        self.amount = amount
        roundIcon.backgroundColor = iconColor
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
    
    private lazy var roundIcon = RoundIcon()
    
    private lazy var categoryName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.cellFontSize)
        return label
    }()
    
    private lazy var categoryAmount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.cellFontSize)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var arrowView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            roundIcon, categoryName, categoryAmount, arrowView
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Constants.cellElementSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins =
        NSDirectionalEdgeInsets(top: 0,
                                leading: Constants.cellElementSpacing,
                                bottom: 0,
                                trailing: Constants.cellElementSpacing)
        return stack
    }()
    
    func setupStackView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: Constants.iconHeight + Constants.cellPadding * 2),
            roundIcon.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            roundIcon.widthAnchor.constraint(equalToConstant: Constants.iconHeight)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if viewModel != nil {
            contentView.backgroundColor = Color.controlBG
        }
        else if selected {
            contentView.backgroundColor = .gray
        } else {
            contentView.backgroundColor = Color.controlBG
        }
    }
    
    // TODO: a bit on how it works
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.layer.cornerRadius = 0
        self.roundSide = .none
    }
}

// MARK: - Constants
extension GraphTableViewCell {
    private enum Constants {
        static let cellCornerRadius: CGFloat = 10
        static let cellFontSize: CGFloat = 20
        static let cellElementSpacing: CGFloat = 15
        static let cellPadding: CGFloat = 15
        static let iconHeight: CGFloat = 40
    }
}
