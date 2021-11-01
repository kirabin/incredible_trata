//
//  CustomCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 25.10.2021.
//
//
import CoreData
import UIKit

final class CustomCell: UITableViewCell {
    
    let sizeImageView: CGFloat = 35
    let sizeLogoImageView: CGFloat = 20
    
    var viewModel = CustomCellViewModel(categories: .transport, subtitle: "home", price: 24) {
        
        didSet {
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            layoutIfNeeded()
        }
    }
    
    var indexCell = (first:false, last:false) {
        didSet {
            if indexCell.first && indexCell.last {
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
            else if indexCell.first {
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            }
            else if indexCell.last {
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
        let imageName = UIImage(systemName: viewModel.imageName)!
        let imageView = UIImageView(image: imageName)
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
}


