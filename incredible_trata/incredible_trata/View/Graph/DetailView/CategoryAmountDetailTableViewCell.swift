//
//  CategoryAmountDetailTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 09.11.2021.
//  

import Foundation
import UIKit

class CategoryAmountDetailTableViewCell: UITableViewCell {

    // MARK: - Private Properties
    private var record: Record? {
        didSet {
            guard let record = record else {
                return
            }
            noteLabel.text = record.note
            amountLabel.text = "\(record.currency?.symbol ?? "?")\(record.amount)"
            roundIcon.imageName = record.category?.imageName ?? ""
        }
    }

    // MARK: - SubViews
    private lazy var roundIcon = RoundIcon()

    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            roundIcon, noteLabel, amountLabel
        ])
        stack.spacing = 10
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins =
        NSDirectionalEdgeInsets(top: Constants.padding,
                                leading: Constants.padding,
                                bottom: Constants.padding,
                                trailing: Constants.padding)
        return stack
    }()

    // MARK: - Initialization
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

    // MARK: - Public Methods
    func configure(record: Record) {
        self.record = record
    }

    // MARK: - Private Methods
    private func setupStackView() {
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roundIcon.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            roundIcon.widthAnchor.constraint(equalToConstant: Constants.iconHeight)
        ])
    }
}

// MARK: - Constants
extension CategoryAmountDetailTableViewCell {
    private enum Constants {
        static let padding: CGFloat = 15
        static let iconHeight: CGFloat = 40
    }
}
