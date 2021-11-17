//
//  AddCategoryViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 31.10.2021.
//  
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {

    init(parentCategory: Category? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.parentCategory = parentCategory
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var parentCategory: Category? {
        didSet {
            parentCategoryChanged()
        }
    }

    func parentCategoryChanged() {
        guard let parentCategory = parentCategory else {
            return
        }
        parentCategoryButton.setTitle(parentCategory.lableName, for: .normal)
    }

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

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Color.mainBG
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.placeholder = "Enter the title"
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter the title",
            attributes: [NSAttributedString.Key.foregroundColor: Color.textBG.withAlphaComponent(0.6)]
        )
        return textField
    }()

    private lazy var parentCategoryButton: UIButton = {
        let image = UIImage(systemName: "chevron.down.circle.fill")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setTitle("None", for: .normal)
        button.addTarget(self, action: #selector(parentCategoryButtonTapped), for: .touchUpInside)
        return button
    }()

    @objc
    func parentCategoryButtonTapped() {
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.delegate = self
        let navVC = UINavigationController(rootViewController: categoriesViewController)
        navVC.navigationBar.barTintColor = .none
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.present(navVC, animated: true)
    }

    private lazy var parentCategoryStack: UIStackView = {
        let label = UILabel()
        label.text = "Parent"
        label.textColor = Color.textBG
        label.font = UIFont.boldSystemFont(ofSize: 25)

        let stack = UIStackView(arrangedSubviews: [
            label, parentCategoryButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 15,
            leading: 10,
            bottom: 15,
            trailing: 15
        )
        return stack
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
        parentCategoryChanged()
    }

    @objc func saveButton() {
        guard let imageNumber = imageNumber, titleTextField.text != "" else {return}
        CoreDataManager.shared.createCategory(
            lableName: titleTextField.text,
            imageName: Default.imageNames[imageNumber],
            parentCategory: parentCategory
        )
        navigationController?.popViewController(animated: true)
    }

    func setConstraints() {
        view.addSubview(castomCollectoinView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleTextFieldLabel)
        view.addSubview(parentCategoryStack)

        NSLayoutConstraint.activate([
            titleTextFieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                     constant: Default.cellElementSpacing),
            titleTextFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Default.cellElementSpacing),
            titleTextFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: Default.lableTrailing),

            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: Default.cellElementSpacing),
            titleTextField.leadingAnchor.constraint(equalTo: titleTextFieldLabel.trailingAnchor,
                                                    constant: Default.zero),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.lableSpase),
            titleTextField.heightAnchor.constraint(equalToConstant: Default.textFieldHeight),

            parentCategoryStack.topAnchor.constraint(equalTo: titleTextFieldLabel.bottomAnchor),
            parentCategoryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parentCategoryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            parentCategoryStack.heightAnchor.constraint(greaterThanOrEqualToConstant: Default.textFieldHeight),

            titleLabel.topAnchor.constraint(equalTo: parentCategoryStack.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Default.cellElementSpacing),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Default.zero),
            titleLabel.heightAnchor.constraint(equalToConstant: Default.LabeleHeight),

            castomCollectoinView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            castomCollectoinView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Default.cellElementSpacing),
            castomCollectoinView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Default.lableSpase),
            castomCollectoinView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                         constant: Default.collectionViewBottom)
        ])
    }
}

extension AddCategoryViewController: CategoriesViewControllerDelegate {
    func categoryWasSelected(category: Category) {
        parentCategory = category
    }
}

// MARK: - Constants
extension AddCategoryViewController {
    enum Default {
        static let lableTrailing: CGFloat = -200
        static let zero: CGFloat = 0
        static let textFieldHeight: CGFloat = 40
        static let textFieldWidth: CGFloat = 100
        static let collectionViewBottom: CGFloat = -50
        static let LabeleHeight: CGFloat = 50
        static let lableSpase: CGFloat = -10
        static let collectoinViewTop: CGFloat = 200
        static let cellElementSpacing: CGFloat = 10

        static let imageNames = [
            "graduationcap.circle",
             "camera.shutter.button.fill",
             "bubble.left.circle.fill",
             "screwdriver",
             "suitcase.cart",
             "tram.fill.tunnel",
             "pawprint",
             "cup.and.saucer.fill",
             "cart.badge.plus",
             "wifi",
             "cross.circle.fill",
             "fork.knife",
             "books.vertical",
             "fuelpump",
             "film",
             "gamecontroller",
             "tv",
             "bicycle",
             "brain.head.profile",
             "leaf.fill",
             "bolt.fill",
             "paintbrush.pointed",
             "clock.fill",
             "pills.fill",
             "flame.fill",
             "scooter",
             "ferry",
             "person.crop.circle",
             "hand.thumbsup",
             "person.text.rectangle",
             "printer",
             "ipad.homebutton",
             "photo.tv",
             "hand.raised.fill",
             "phone.fill",
             "video",
             "envelope",
             "pencil.circle",
             "trash",
             "paperplane.circle.fill",
             "sun.dust",
             "moon",
             "music.note",
             "magnifyingglass",
             "mic",
             "flag.2.crossed",
             "star.fill",
             "eyeglasses",
             "scissors",
             "creditcard.fill"
        ]
    }
}
