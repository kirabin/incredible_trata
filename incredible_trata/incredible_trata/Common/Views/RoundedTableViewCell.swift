//
//  RoundedTableViewCell.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 16.11.2021.
//  

import UIKit

class RoundedTableViewCell: UITableViewCell {

    // MARK: - Public Properties
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

    // MARK: - Types
    enum RoundSide {
        case none
        case top
        case bottom
        case all
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        roundSide = .none
    }

    // MARK: - Public Methods
    final func setRoundSide(tableView: UITableView, indexPath: IndexPath) {
        let rowsTotal = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
        let row = indexPath.row
        if row == 0 && row == rowsTotal - 1 {
            roundSide = .all
        } else if row == 0 {
            roundSide = .top
        } else if row == rowsTotal - 1 {
            roundSide = .bottom
        }
    }
}

// MARK: - Constants
extension RoundedTableViewCell {
    private enum Constants {
        static let cellCornerRadius: CGFloat = 10
    }
}
