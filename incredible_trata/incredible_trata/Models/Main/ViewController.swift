//
//  ViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
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
    
    let idCell = "idCell"
    
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
        
        setConstraints()
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(castomTableView)
        castomTableView.delegate = self
        castomTableView.dataSource = self
        castomTableView.register(CustomCell.self, forCellReuseIdentifier: idCell)
    }
    
    let groupSection = ["1","2"]
    let itemsInfoArrays = [
    ["1111111111111111"],
    ["1.4","1.5","1.6"],
    ["22", "33"],
    ["6","7", "8"],
    ["26","27", "28"]
    ]

    let castomTableView: UITableView = {
        let castomTableView = UITableView()
        castomTableView.translatesAutoresizingMaskIntoConstraints = false
        castomTableView.backgroundColor = .black
        return castomTableView
    }()

    func setConstraints() {
        view.addSubview(castomTableView)
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomConstraint,
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        NSLayoutConstraint.activate([castomTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0), castomTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130.0), castomTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0), castomTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65.0)])
    }
        
    override func loadView() {
        view = UIView()
        view.backgroundColor = Color.mainBG
        view.addSubview(addItemBar)
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
