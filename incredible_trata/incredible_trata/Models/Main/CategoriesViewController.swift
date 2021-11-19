//
//  CategoriesViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import UIKit
import CoreData

protocol CategoriesViewControllerDelegate: AnyObject {
    func categoryWasSelected(category: Category)
}

class CategoriesViewController: UIViewController {

    init(category: Category? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.parentCategory = category
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var addCategoryButton = UIButton()

    weak var delegate: CategoriesViewControllerDelegate?

    private var categories: [Category] = [] {
        didSet {
            self.categoriesTableView.reloadData()
        }
    }

    private var parentCategory: Category?

    private func setCategories() {
        if let category = parentCategory {
            categories = [category]
            categories.append(contentsOf: category.nestedCategoriesArray)
        } else {
            let predicate = NSPredicate(format: "parentCategory = nil")
            categories = CoreDataManager.shared.getCategories(with: predicate)
        }
    }

    private lazy var categoriesTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Color.mainBG
        table.layer.cornerRadius = 10
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a category"
        view.backgroundColor = Color.mainBG
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action:
                                                            #selector(actionBarItems))
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.inputFG]
        navigationController?.navigationBar.tintColor = Color.inputFG
        setConstraints()
        setCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        setCategories()
    }

    @objc func actionBarItems() {
        let addCategoryVC = AddCategoryViewController(parentCategory: parentCategory)
        navigationController?.pushViewController(addCategoryVC, animated: true)
    }

    func setConstraints() {
        view.addSubview(categoriesTableView)
        NSLayoutConstraint.activate([
            categoriesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
            categoriesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            categoriesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0)
        ])
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryTableViewCell = tableView.regCell(indexPath: indexPath)
        else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        // TODO: ugly
        if self.parentCategory != nil && self.parentCategory == category {
            cell.showNestedArrow = false
        }
        cell.setRoundSide(tableView: tableView, indexPath: indexPath)
        cell.category = category

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        if self.parentCategory == category || category.nestedCategoriesArray.isEmpty {
            delegate?.categoryWasSelected(category: category)
            self.dismiss(animated: true, completion: nil)
        } else {
            let categoriesVeiwController = CategoriesViewController(category: category)
            categoriesVeiwController.delegate = self.delegate
            navigationController?.pushViewController(categoriesVeiwController, animated: true)
        }
    }
}
