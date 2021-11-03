//
//  RecordTableViewCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 25.10.2021.
//
//
import CoreData
import UIKit

final class RecordTableViewCell: UITableViewCell {
    
    var viewModel = CustomCellViewModel(categories: .transport, subtitle: "home", price: 24) {
        
        didSet {
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            layoutIfNeeded()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        contentView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case (first:false, last:true):
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            case (first:true, last:false):
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            case (first:false, last:false):
                self.contentView.layer.cornerRadius = 0
                self.contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        view.layer.cornerRadius = Default.sizeImageView / 2
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

extension RecordTableViewCell {
    enum Default {
        static let sizeImageView: CGFloat = 35
        static let sizeLogoImageView: CGFloat = 20
    }
}


