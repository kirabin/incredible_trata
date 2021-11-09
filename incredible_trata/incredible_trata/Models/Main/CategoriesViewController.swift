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
        let CategoriesTableView = UITableView()
        CategoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        CategoriesTableView.backgroundColor = .black
        CategoriesTableView.layer.cornerRadius = 10
        return CategoriesTableView
    }()
    
    let idCell = "idCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a category"
        view.backgroundColor = .black
        self.view.addSubview(categoriesTableView)
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.bounces = false
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: idCell)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action:
                                                            #selector(actionBarItems))
        self.navigationController?.navigationBar.tintColor = .white
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

        NSLayoutConstraint.activate([categoriesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
                                     categoriesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
                                     categoriesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0),
                                     categoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0)])
    }
}
