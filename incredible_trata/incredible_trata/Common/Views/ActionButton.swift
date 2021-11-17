//
//  ActionButton.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 10.11.2021.
//

import UIKit

class ActionButton: UIButton {

    // MARK: - Private Properties
    private var action: () -> Void

    // MARK: - Initializaiton
    init(with action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(oAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    @objc
    private func oAction() {
        action()
    }
}
