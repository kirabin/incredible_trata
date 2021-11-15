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
        castomCollectionView.backgroundColor = Color.mainBG
        return castomCollectionView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сhoose a picture"
        label.textColor = Color.inputFG
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    private lazy var titleTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.textColor = Color.textBG
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Color.mainBG
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.placeholder = "Enter the title"
        textField.attributedPlaceholder = NSAttributedString(string: "Enter the title",
                                                             attributes: [NSAttributedString.Key.foregroundColor:
                                                                            Color.textBG.withAlphaComponent(0.6)])
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBG

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain,
                                                            target: self, action: #selector(saveButton))
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

        NSLayoutConstraint.activate([castomCollectoinView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                                                constant: Default.cellElementSpacing),
                                     castomCollectoinView.topAnchor.constraint(equalTo: view.topAnchor,
                                                                               constant: Default.collectoinViewTop),
                                     castomCollectoinView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                                 constant: Default.lableSpase),
                                     castomCollectoinView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                constant: Default.collectionViewBottom),
                                     textField.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                                       constant: Default.lableSpase),
                                     textField.leadingAnchor.constraint(equalTo: titleTextFieldLabel.trailingAnchor,
                                                                        constant: Default.zero),
                                     textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                         constant: Default.lableSpase),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                    constant: Default.cellElementSpacing),
                                     textField.heightAnchor.constraint(equalToConstant: Default.textFieldHeight),
                                     titleTextFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                                                  constant: Default.cellElementSpacing),
                                     titleTextFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                                   constant: Default.lableTrailing),
                                     titleTextFieldLabel.topAnchor.constraint(equalTo:
                                                                                view.safeAreaLayoutGuide.topAnchor,
                                                                              constant: Default.cellElementSpacing),
                                     titleTextFieldLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                                                 constant: Default.lableSpase),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                                         constant: Default.cellElementSpacing),
                                     titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                                       constant: Default.zero),
                                     titleLabel.bottomAnchor.constraint(equalTo: castomCollectoinView.topAnchor,
                                                                        constant: Default.lableSpase),
                                     titleLabel.heightAnchor.constraint(equalToConstant: Default.LabeleHeight)])
    }

}

// MARK: - Constants

extension AddCategoryViewController {
    enum Default {
        static let lableTrailing: CGFloat = -200
        static let zero: CGFloat = 0
        static let textFieldHeight: CGFloat = 40
        static let collectionViewBottom: CGFloat = -50
        static let LabeleHeight: CGFloat = 50
        static let lableSpase: CGFloat = -10
        static let collectoinViewTop: CGFloat = 200
        static let cellElementSpacing: CGFloat = 10

        static let images = ["graduationcap.circle", "camera.shutter.button.fill",
                             "bubble.left.circle.fill", "screwdriver",
                             "suitcase.cart", "tram.fill.tunnel",
                             "pawprint", "cup.and.saucer.fill",
                             "cart.badge.plus", "wifi",
                             "cross.circle.fill", "fork.knife",
                             "books.vertical", "fuelpump",
                             "film", "gamecontroller", "tv",
                             "bicycle", "brain.head.profile", "leaf.fill",
                             "bolt.fill", "paintbrush.pointed", "clock.fill",
                             "pills.fill", "flame.fill", "scooter",
                             "ferry", "person.crop.circle", "hand.thumbsup",
                             "person.text.rectangle",
                             "printer", "ipad.homebutton", "photo.tv",
                             "hand.raised.fill", "phone.fill", "video",
                             "envelope", "pencil.circle", "trash",
                             "paperplane.circle.fill", "sun.dust", "moon",
                             "music.note", "magnifyingglass", "mic",
                             "flag.2.crossed", "star.fill", "eyeglasses",
                             "scissors", "creditcard.fill"]
    }
}
