//
//  AppearanceTableViewCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 09.11.2021.
//  
//

import Foundation
import UIKit

class AppearanceTableViewCell: UITableViewCell {

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
    
    private var viewModel: AppearanceTableViewCellModel! {
        didSet {
            labelView.text = viewModel.text
            if viewModel.selected == true {
                arrowView.isHidden = true
            }
            if viewModel.selected == false {
                arrowView.isHidden = false
            }
        }
    }
    
    func configure(viewModel: AppearanceTableViewCellModel) {
        self.viewModel = viewModel
    }
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.textColor = Color.textBG
        label.font = label.font.withSize(Constants.cellFontSize)
        return label
    }()
    
    
    private lazy var arrowView: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: image)
        imageView.tintColor = Color.textBG
        imageView.isHidden = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
                labelView, arrowView
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
            stackView.heightAnchor.constraint(equalTo: arrowView.heightAnchor,
                                              constant: Constants.cellPadding * 2)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.arrowView.isHidden = true
        self.backgroundColor = .clear
    }
}

// MARK: - Constants
extension AppearanceTableViewCell {
    private enum Constants {
        static let cellCornerRadius: CGFloat = 5
        static let cellFontSize: CGFloat = 20
        static let cellElementSpacing: CGFloat = 15
        static let cellPadding: CGFloat = 15
        static let iconHeight: CGFloat = 40
    }
}

class AppearanceTableViewCellModel {
    var cellType: SettingsRowType
    var text: String
    var selected: Bool
    var action: ((Bool?) -> Void)?
    
    init(cellType: SettingsRowType, text: String, switched: Bool) {
        self.cellType = cellType
        self.text = text
        self.selected = switched
    }
}
