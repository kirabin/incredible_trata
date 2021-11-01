//
//  NavigationController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//  

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
