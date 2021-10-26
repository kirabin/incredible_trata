//
//  AddCategoryViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import Foundation
import UIKit
import CoreData


class AddCategoryViewController: UIViewController {
    
    var imageNumber: Int?
    private lazy var castomCollectoinView: UICollectionView = {
        let castomCollectionView = UICollectionView(frame: CGRect.zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout.init())
        castomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castomCollectionView.backgroundColor = .black
        return castomCollectionView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сhoose a picture"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private lazy var titleTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.159709245, green: 0.1699241698, blue: 0.1888181865, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 0.159709245, green: 0.1699241698, blue: 0.1888181865, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.placeholder = "Enter the title"
        textField.attributedPlaceholder = NSAttributedString(string: "Enter the title",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        castomCollectoinView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        castomCollectoinView.delegate = self
        castomCollectoinView.dataSource = self
        setConstraints()
        
    }
    
    @objc func saveButton() {
        if textField.text == "" || imageNumber == nil {
            return
        }
        CoreDataManager.shared.creatCategory(lableName: textField.text, imageName:
                                                AddCategoryViewController.Default.images[imageNumber!])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func setConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(castomCollectoinView)
        view.addSubview(textField)
        view.addSubview(titleTextFieldLabel)
        
        NSLayoutConstraint.activate([castomCollectoinView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
                                     castomCollectoinView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200.0),
                                     castomCollectoinView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0),
                                     castomCollectoinView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0),
                                     textField.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
                                     textField.leadingAnchor.constraint(equalTo: titleTextFieldLabel.trailingAnchor, constant: 0),
                                     textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     textField.heightAnchor.constraint(equalToConstant: 40),
                                     titleTextFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                                     titleTextFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200),
                                     titleTextFieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     titleTextFieldLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                                     titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                                     titleLabel.bottomAnchor.constraint(equalTo: castomCollectoinView.topAnchor, constant: -10),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 50)])
    }

}

// MARK: - Constants

extension AddCategoryViewController {
    enum Default {
        static let images = ["graduationcap.circle","camera.shutter.button.fill",
                             "bubble.left.circle.fill","screwdriver",
                             "suitcase.cart","tram.fill.tunnel",
                             "pawprint","cup.and.saucer.fill",
                             "cart.badge.plus","wifi",
                             "cross.circle.fill","fork.knife",
                             "books.vertical","fuelpump",
                             "film","gamecontroller","tv",
                             "bicycle","brain.head.profile","leaf.fill",
                             "bolt.fill","paintbrush.pointed","clock.fill",
                             "pills.fill","flame.fill","scooter",
                             "ferry","person.crop.circle","hand.thumbsup",
                             "person.text.rectangle",
                             "printer","ipad.homebutton","photo.tv",
                             "hand.raised.fill","phone.fill","video",
                             "envelope","pencil.circle","trash",
                             "paperplane.circle.fill","sun.dust","moon",
                             "music.note","magnifyingglass","mic",
                             "flag.2.crossed","star.fill","eyeglasses",
                             "scissors","creditcard.fill"]
    }
}
