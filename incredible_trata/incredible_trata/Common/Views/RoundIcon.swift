//
//  RoundIcon.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 02.11.2021.
//

import Foundation
import UIKit

class RoundIcon: UIView {

    // MARK: - Public Properties
    var imageName: String? {
        didSet {
            iconView.image = UIImage(systemName: imageName ?? "")
        }
    }

    // MARK: - Private Properties
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.textBG
        return imageView
    }()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)

        self.backgroundColor = Color.iconBG
        self.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(iconView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(imageName: String) {
        self.init()
        self.imageName = imageName
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }

    // MARK: - Private Methods
    private func setConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
