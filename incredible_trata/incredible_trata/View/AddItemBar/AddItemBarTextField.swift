//
//  AddItemBarTextField.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 26.10.2021.
//

import Foundation
import UIKit

class AddItemBarTextField: UITextField {

    init() {
        super.init(frame: .zero)

        self.backgroundColor = Color.controlBG
        self.textAlignment = .center
        self.textColor = Color.mainBG
        self.attributedPlaceholder = NSAttributedString(
            string: "?",
            attributes: [NSAttributedString.Key.foregroundColor: Color.inputFG]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
