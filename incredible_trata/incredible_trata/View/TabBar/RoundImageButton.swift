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
    var height: CGFloat
    var color: UIColor
    
    init(image: UIImage!, height: CGFloat, color: UIColor) {
        self.height = height
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
        self.layer.cornerRadius = self.height / 2
        self.backgroundColor = color
    }
}
