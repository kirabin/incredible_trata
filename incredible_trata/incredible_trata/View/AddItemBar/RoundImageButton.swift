//
//  RoundImageButton.swift
//  incredible_trata
//
//  Created by a19658227 on 25.10.2021.
//

import Foundation
import UIKit

class RoundImageButton: UIButton {
    var image: UIImage!
    var color: UIColor
    
    init(image: UIImage!, color: UIColor) {
        self.color = color
        self.image = image
        super.init(frame: .zero)
        createButton()
    }
    
    // NOTE: Called then adding class through storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createButton() {
        self.setImage(image, for: .normal)
        self.tintColor = .white
        self.backgroundColor = color
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
