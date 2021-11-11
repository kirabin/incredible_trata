//
//  CategoryTableViewCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import CoreData
import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoImageView, titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.iconBG
        view.layer.cornerRadius = Default.sizeImageView / 2
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.textBG
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var viewModel: Category?  = nil {
        didSet {
            let imageName = UIImage(systemName: viewModel?.imageName ?? "home")
            logoImageView.image = imageName
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.tintColor = Color.textBG
            titleLabel.text = viewModel?.lableName

        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        contentView.backgroundColor = Color.controlBG
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var indexCell = (first:false, last:false) {
        didSet {
            switch indexCell {
                
            case (first:true, last:true):
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner,
                                                        .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case (first:false, last:true):
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            case (first:true, last:false):
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            case (first:false, last:false):
                self.contentView.layer.cornerRadius = 0
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner,
                                                        .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
    }
    
    private func setupUI() {
        addSubviews()
        setupLayout()
       
    }
    
    private func addSubviews() {
        contentView.addSubview(imageBackgroundView)
        contentView.addSubview(horizontalStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Default.sizeLogoImageView),
            imageBackgroundView.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            imageBackgroundView.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: Default.sizeImageView),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: Default.sizeImageView)
        ])
        horizontalStackView.setCustomSpacing(15, after: logoImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 0
        indexCell = (false, false)
    }
}

// MARK: - Constants

extension CategoryTableViewCell {
    enum Default {
        static let sizeImageView: CGFloat = 35
        static let sizeLogoImageView: CGFloat = 20
    }
}

