//
//  RoundIcon.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 02.11.2021.
//  

import Foundation
import UIKit

class RoundIcon: UIView {
    
    var imageName: String! {
        didSet {
            iconView.image = UIImage(systemName: imageName)
        }
    }
    
    var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.textBG
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = Color.iconBG
        self.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(iconView)
        setConstraints()
    }
    
    func setConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
