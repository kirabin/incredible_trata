//
//  MonthSelectionTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 12.11.2021.
//  

import Foundation
import UIKit

class MonthSelectionTableViewCell: UITableViewCell {

    // MARK: - Private Properties
    private var text: String = "" {
        didSet {
            dateLabel.text = text
        }
    }

    // MARK: - SubViews
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.tintColor = Color.textBG
        label.font = label.font.withSize(20)
        return label
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
    func configure(text: String) {
        self.text = text
    }

    // MARK: - Private Methods
    private func setupCell() {
        self.backgroundColor = .clear
        contentView.addSubview(dateLabel)
        contentView.backgroundColor = Color.controlBG
        contentView.layer.cornerRadius = 10
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
