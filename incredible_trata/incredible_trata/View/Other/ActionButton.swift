//
//  ActionButton.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 10.11.2021.
//

import Foundation
import UIKit

class ActionButton: UIButton {

    private var action: () -> Void

    init(with action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(oAction), for: .touchUpInside)
    }

    @objc
    private func oAction() {
        action()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
