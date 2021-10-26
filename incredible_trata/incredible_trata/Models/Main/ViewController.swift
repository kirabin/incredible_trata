//
//  ViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit




class ViewController: UIViewController {
    var addItemBar: AddItemBar!

    private let backgroundColor = UIColor(red: 17.0 / 255.0, green: 17.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
    
    // TODO: Difference betwee viewDidLoad and loadView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = backgroundColor
        // TODO: add shadow
        addItemBar = AddItemBar()
        view.addSubview(addItemBar)
        setConstraints()
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                // TODO: move tabBar only
                // TODO: get rid of hard codded +20
                // moves root view up by the distance of keyboard height
                self.view.frame.origin.y = -keyboardSize.height + 20
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
            self.view.frame.origin.y = 0
    }
    
    func setConstraints() {
        let padding: CGFloat = 15.0
        // TODO: how to better set bottom padding?
        let paddingBottom: CGFloat = padding + 20
        
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addItemBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingBottom),
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
}
