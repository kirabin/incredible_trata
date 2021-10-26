//
//  ViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var bottomConstraint:NSLayoutConstraint = {
        let constraint = addItemBar
                            .bottomAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        return constraint
    }()
    
    private let addItemBar: AddItemBar = {
        let itemBar = AddItemBar()
        return itemBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = Color.mainBG
        view.addSubview(addItemBar)
        setConstraints()
    }
    
    private func setConstraints() {
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomConstraint,
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                        .cgRectValue {
            bottomConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()  // Updates layout with animation if needed
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}
