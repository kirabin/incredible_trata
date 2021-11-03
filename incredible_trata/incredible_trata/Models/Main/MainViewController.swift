//
//  MainViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit
import CoreData
import Foundation

class MainViewController: UIViewController {
    
    private lazy var bottomConstraint: NSLayoutConstraint = {
        addItemBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()
    
    private lazy var addItemBar: AddItemBar = {
        let bar = AddItemBar()
        bar.delegate = self
        return bar
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = RoundButton(with: UIImage(systemName: "gearshape"))
        button.backgroundColor = Color.headerButtonBG
        button.tintColor = .white
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    func settingsButtonTapped() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    let categoryVC = UIViewController()
    let groupSection = ["1","2","3","4","5"]
    let itemsInfoArrays = [
    ["1111111111111111"],
    ["1.4","1.5","1.6"],
    ["22", "33"],
    ["6","7", "8"],
    ["26","27", "28"]
    ]

    let idCell = "idCell"
    
    override func loadView() {
        
        DefaultsManager.shared.populateCoreDataIfNeeded()
        view = UIView()
        view.backgroundColor = Color.mainBG
        navigationItem.backButtonTitle = ""
        view.addSubview(castomTableView)
        view.addSubview(addItemBar)
        view.addSubview(settingsButton)
        setConstraints()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        castomTableView.delegate = self
        castomTableView.dataSource = self
        castomTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: idCell)
        DefaultsManager.shared.populateCoreDataIfNeeded()
        DefaultsManager.shared.populateCoreData()

    }

    let castomTableView: UITableView = {
        let castomTableView = UITableView()
        castomTableView.translatesAutoresizingMaskIntoConstraints = false
        castomTableView.backgroundColor = Color.mainBG
        return castomTableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        addItemBar.updateAmountField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setConstraints() {
        addItemBar.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomConstraint,
            addItemBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addItemBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 60),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])

        NSLayoutConstraint.activate([castomTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0), castomTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130.0), castomTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0), castomTableView.bottomAnchor.constraint(equalTo: addItemBar.topAnchor, constant: 0)])
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

extension MainViewController: CategoriesViewControllerDelegate {
    func categoryWasSelected(category: Category) {
        
    }
}

extension MainViewController: AddItemBarDelegate {
    func addButtonTapped(noteValue: String?, priceValue: String?, completionHandler: () -> Void) {
        guard let noteValue = noteValue,
              let priceValue = priceValue,
              !priceValue.isEmpty,
              let selectedCurrency = CoreDataManager.shared.getUserSelectedCurrency()
        else {
            return
        }
        do {
            try CoreDataManager.shared.saveRecord(note: noteValue,
                                                  amount: Int64(priceValue) ?? 0,
                                                  currency: selectedCurrency)
            completionHandler()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func categoryButtonTapped() {
        // TODO: implement
        let categoryVC = CategoriesViewController()
        let navVC = UINavigationController(rootViewController: categoryVC)
        
        categoryVC.delegate = self
        navVC.navigationBar.barTintColor = .none
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.present(navVC, animated: true)
    }

}
