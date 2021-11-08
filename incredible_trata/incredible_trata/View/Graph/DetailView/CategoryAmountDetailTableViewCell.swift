//
//  CategoryAmountDetailTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 09.11.2021.
//  

import Foundation
import UIKit

class CategoryAmountDetailTableViewCell: UITableViewCell {
    
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
    
    private var viewModel: Record? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            noteLabel.text = viewModel.note
            amountLabel.text = "\(viewModel.currency!.symbol!)\(viewModel.amount)"
        }
    }
    
    func configure(viewModel: Record) {
        self.viewModel = viewModel
    }
    
    
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
            noteLabel, amountLabel
        ])
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins =
        NSDirectionalEdgeInsets(top: Constants.padding,
                                leading: Constants.padding,
                                bottom: Constants.padding,
                                trailing: Constants.padding)
        return stack
    }()
    
    func setupStackView() {
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

// MARK: - Constants
extension CategoryAmountDetailTableViewCell {
    private enum Constants {
        static let padding: CGFloat = 15
    }
}
