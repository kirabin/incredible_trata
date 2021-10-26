//
//  ViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var bottomConstraint:NSLayoutConstraint = {
        let constraint = addItemBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        return constraint
    }()
    
    private let addItemBar: AddItemBar = {
        let itemBar = AddItemBar()
        
        return itemBar
    }()
    
    private var middleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = Constants.backgroundColor
        
        middleView = UIView() // TODO: remove this view
        middleView.backgroundColor = .red.withAlphaComponent(0.6)
        middleView.layer.cornerRadius = 20
        
        view.addSubview(middleView)
        view.addSubview(addItemBar)
        setConstraints()
    }
    
    private func setConstraints() {
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        middleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomConstraint,
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            middleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            middleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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

// MARK: - Constants
extension ViewController {
    private enum Constants {
        static let backgroundColor = UIColor(red: 17.0 / 255.0, green: 17.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
    }
}
