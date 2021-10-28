//
//  Cell.swift
//  incredible_trata
//
//  Created by 19663308 on 25.10.2021.
//
//

import UIKit

final class CustomCell: UITableViewCell {
    
    private lazy var sizeImageView: CGFloat = 35
    private lazy var sizeLogoImageView: CGFloat = 20
    
    var viewModel = CustomCellViewModel(categories: .transport, subtitle: "home", price: 24) {
        
        didSet {
            logoImageView.image = viewModel.image
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            layoutIfNeeded()
        }
    }
    var indexCell: [String: Bool] = ["First": false, "Last": false] {
        didSet {
            if indexCell["First"]!  && (indexCell["Last"]!) {
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
            else if indexCell["First"]! {
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            }
            else if indexCell["Last"]! {
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            }
        }
    }
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoImageView, verticalStackView, priceLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.159709245, green: 0.1699241698, blue: 0.1888181865, alpha: 1)
        view.layer.cornerRadius = sizeImageView / 2
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.subtitle
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  "£" + String(viewModel.price)
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            logoImageView.widthAnchor.constraint(equalToConstant: sizeLogoImageView),
            imageBackgroundView.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            imageBackgroundView.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: sizeImageView),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: sizeImageView)
        ])
        horizontalStackView.setCustomSpacing(15, after: logoImageView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
}

struct CustomCellViewModel {
    
    let image: UIImage
    let title: String
    let subtitle: String
    let price: Int
    init(categories: CustomCellCategorie, subtitle: String, price: Int) {
        
        self.title = categories.title
        self.image = UIImage(systemName: categories.imageName)!
        self.subtitle = subtitle
        self.price = price
    }
}
