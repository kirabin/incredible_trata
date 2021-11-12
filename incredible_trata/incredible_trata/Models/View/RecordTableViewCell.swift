//
//  RecordTableViewCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 25.10.2021.
//
//
import CoreData
import UIKit

final class RecordTableViewCell: RoundedTableViewCell {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.textBG
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        contentView.backgroundColor = Color.controlBG
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = Color.mainBG
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.textBG.withAlphaComponent(0.6)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = Color.textBG
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private var viewModel: Record? {
        didSet {
            subtitleLabel.text = viewModel?.note
            priceLabel.text = (viewModel?.currency?.symbol)! + String((viewModel?.amount)!)
            titleLabel.text = viewModel?.category?.lableName
            let image = UIImage(systemName: (viewModel?.category?.imageName)!)
            logoImageView.image = image
            logoImageView.tintColor = Color.textBG
        }
    }

    func configure(viewModel: Record) {
        self.viewModel = viewModel
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
    }
}

// MARK: - Constants

extension RecordTableViewCell {
    enum Default {
        static let sizeImageView: CGFloat = 35
        static let sizeLogoImageView: CGFloat = 20
        static let cornerRadiusTrue: CGFloat = 10
        static let cornerRadiusFalse: CGFloat = 0
    }
}
