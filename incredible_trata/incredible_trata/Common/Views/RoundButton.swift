//
//  RoundImageButton.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 25.10.2021.
//

import UIKit

class RoundButton: UIButton {

    // MARK: - Initialization
    init(with image: UIImage? = nil) {
        super.init(frame: .zero)

        if let image = image {
            self.setImage(image, for: .normal)
        }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(with image: UIImage? = nil, size: CGFloat) {
        self.init(with: image)

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size)
        ])
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
