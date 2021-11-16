//
//  NavigationController.swift
//  incredible_trata
//
//  Created by Ryabin Kirill on 29.10.2021.
//  

import Foundation
import UIKit

// TODO: remove
class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.inputFG]
        navigationBar.titleTextAttributes = [.foregroundColor: Color.inputFG]
        navigationBar.tintColor = Color.inputFG
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
