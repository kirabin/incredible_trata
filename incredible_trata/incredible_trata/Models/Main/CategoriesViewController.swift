//
//  CategoriesViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import Foundation
import UIKit
import CoreData

protocol CategoriesViewControllerDelegate: AnyObject {
    func categoryWasSelected(category: Category)
}

class CategoriesViewController: UIViewController {
    
    var addCategoryButton = UIButton()
    var category: Category?
    weak var delegate: CategoriesViewControllerDelegate?
    var categories = CoreDataManager.shared.getAllCategories()

    let categoriesTableView: UITableView = {
        let сategoriesTableView = UITableView()
        сategoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        сategoriesTableView.backgroundColor = Color.mainBG
        сategoriesTableView.layer.cornerRadius = 10
        return сategoriesTableView
    }()

    let idCell = "idCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a category"
        view.backgroundColor = Color.mainBG
        self.view.addSubview(categoriesTableView)
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.bounces = false
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: idCell)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action:
                                                            #selector(actionBarItems))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.inputFG]
        navigationController?.navigationBar.tintColor = Color.inputFG
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        categories = CoreDataManager.shared.getAllCategories()
        self.categoriesTableView.reloadData()
    }

    @objc func actionBarItems() {
        let addCategoryVC = AddCategoryViewController()
        navigationController?.pushViewController(addCategoryVC, animated: true)
    }

    func setConstraints() {
        view.addSubview(categoriesTableView)

        NSLayoutConstraint.activate(
            [categoriesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
                                     categoriesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
                                     categoriesTableView.rightAnchor.constraint(equalTo:
                                                                                    view.rightAnchor, constant: -10.0),
                                     categoriesTableView.bottomAnchor.constraint(equalTo:
                                                                                view.bottomAnchor, constant: -50.0)])
    }
}
