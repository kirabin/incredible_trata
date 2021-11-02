//
//  RoundImageButton.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 25.10.2021.
//

import Foundation
import UIKit

class RoundImageButton: UIButton {
    
    init(image: UIImage?, color: UIColor) {
        super.init(frame: .zero)
        
        if let image = image {
            self.setImage(image, for: .normal)
        }
        self.backgroundColor = color
        self.tintColor = .white
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
