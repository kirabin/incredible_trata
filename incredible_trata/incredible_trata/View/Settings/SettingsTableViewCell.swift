//
//  SettingsTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 01.11.2021.
//  

import Foundation
import UIKit


class SettingsTableViewCell: UITableViewCell {

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
    
    private var viewModel: SettingsTableViewCellModel! {
        didSet {
            labelView.text = viewModel.text
            roundIcon.imageName = viewModel.imageName
            switch viewModel.cellType {
                case .blank:
                    break
                case .nested:
                    arrowView.isHidden = false
                case .toggle:
                    toggleView.isHidden = false
                case .check:
                    break
            }
        }
    }
    
    func configure(viewModel: SettingsTableViewCellModel) {
        self.viewModel = viewModel
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
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.textColor = Color.textBG
        label.font = label.font.withSize(Constants.cellFontSize)
        return label
    }()
    
    // TODO: set value depending on usersettings
    private lazy var toggleView: UISwitch = {
        let toggle = UISwitch()
        toggle.isHidden = true
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.addTarget(self, action: #selector(toggleWasTapped), for: .touchUpInside)
        return toggle
    }()
    
    @objc
    func toggleWasTapped() {
        guard let viewModel = self.viewModel,
              let action = viewModel.action
        else {
            return
        }
        action(toggleView.isOn)
    }
    
    private lazy var arrowView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = Color.textBG
        imageView.isHidden = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            roundIcon, labelView, toggleView, arrowView
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
            stackView.heightAnchor.constraint(equalTo: roundIcon.heightAnchor,
                                              constant: Constants.cellPadding * 2),
            roundIcon.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            roundIcon.widthAnchor.constraint(equalToConstant: Constants.iconHeight)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = .gray
        } else {
            contentView.backgroundColor = Color.controlBG
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 0
        self.arrowView.isHidden = true
        self.toggleView.isHidden = true
    }
}

// MARK: - Constants
extension SettingsTableViewCell {
    private enum Constants {
        static let cellCornerRadius: CGFloat = 5
        static let cellFontSize: CGFloat = 20
        static let cellElementSpacing: CGFloat = 15
        static let cellPadding: CGFloat = 15
        static let iconHeight: CGFloat = 40
    }
}
