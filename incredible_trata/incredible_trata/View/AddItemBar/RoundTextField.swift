//
//  RoundTextField.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 26.10.2021.
//

import Foundation
import UIKit

class RoundTextField: UITextField {
    
    init(BGColor: UIColor) {
        super.init(frame: .zero)

        self.backgroundColor = BGColor
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // addSubview calls this func
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
