//
//  CategoryCollectionViewCell.swift
//  incredible_trata
//
//  Created by Aristova Alina on 01.11.2021.
//  
//

import Foundation
import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.textBG
        return imageView
    }()

    var image: String? {
        didSet {
            let imageName = UIImage(systemName: image!)
            logoImageView.image = imageName
        }
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        contentView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)])
    }
}
