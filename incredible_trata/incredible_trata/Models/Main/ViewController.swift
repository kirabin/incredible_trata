//
//  ViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit




class ViewController: UIViewController {
    var tabBar: TabBar!

    private let backgroundColor = UIColor(red: 17.0 / 255.0, green: 17.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        tabBar = TabBar()
        
        view.addSubview(tabBar)
        setConstraints()
    }
    
    func setConstraints() {
        let padding: CGFloat = 15.0
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding - 20),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
}
