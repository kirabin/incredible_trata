//
//  MainViewController.swift
//  incredible_trata
//
//  Created by 16700097 on 25.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let groupSection = ["1","2","3"]
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
    
    let idCell = "idCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(castomTableView)
        castomTableView.delegate = self
        castomTableView.dataSource = self
        castomTableView.register(CustomCell.self, forCellReuseIdentifier: idCell)
     
    }
    
    func setConstraints() {
        view.addSubview(castomTableView)

        NSLayoutConstraint.activate([castomTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0), castomTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130.0), castomTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0), castomTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65.0)])
    }

}

