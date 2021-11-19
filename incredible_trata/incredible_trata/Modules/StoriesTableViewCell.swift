//
//  StoriesTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 17.11.2021.
//  

import UIKit

class StoriesTableViewCell: UITableViewCell {

    // MARK: - Private Properties
    private var amount: String = "" {
        didSet {
            categoryAmount.text = amount
        }
    }

    private var category: Category? {
        didSet {
            guard let category = category else {
                return
            }
            categoryIcon.imageName = category.imageName
            categoryLabel.text = category.lableName
        }
    }

    // MARK: - Subviews
    private lazy var categoryIcon: RoundIcon = {
        let icon = RoundIcon()
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40)
        ])
        icon.backgroundColor = .gray.withAlphaComponent(0.5)
        return icon
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private lazy var categoryAmount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            categoryIcon, categoryLabel, categoryAmount
        ])
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 15,
            leading: 0,
            bottom: 15,
            trailing: 0
        )
        stack.spacing = 15
        return stack
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(category: Category, amount: String) {
        self.category = category
        self.amount = amount
    }

    // MARK: - Private Methods
    private func setupCell() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    }
