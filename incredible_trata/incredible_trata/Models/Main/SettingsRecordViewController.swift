//
//  SettingsRecordViewController.swift
//  incredible_trata
//
//  Created by Aristova Alina on 05.11.2021.
//  
//

import Foundation
import UIKit
import MapKit

// swiftlint:disable type_body_length
class SettingsRecordViewController: UIViewController {
    let locationManager = CLLocationManager()
    var annotations: [MKAnnotation] = []
    var coordinate: CLLocationCoordinate2D?
    var childrenViewContext = CoreDataManager.shared.getChildrenContext()

    private var childrenRecord: Record?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.mainBG
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain,
                                                            target: self, action: #selector(saveButtonAction))
        createGestureRecognizer()
        setConstraints()
    }

    private lazy var amountTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Amount"
        label.textColor  = Color.inputFG
        label.backgroundColor = Color.controlBG
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Color.controlBG
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textColor = Color.inputFG
        textField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
        return textField
    }()

    private lazy var dateTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date"
        label.textColor = Color.inputFG
        label.backgroundColor = Color.controlBG
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private lazy var picker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = Color.controlBG
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .allEvents)
       return datePicker
    }()

    private lazy var categoryTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category"
        label.textColor = Color.inputFG
        label.backgroundColor = Color.controlBG
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private lazy var settingsCategoryButton: UIButton = {
        let settingsCategoryButton = UIButton()
        settingsCategoryButton.tintColor = Color.inputFG
        settingsCategoryButton.backgroundColor = Color.controlBG
        settingsCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        settingsCategoryButton.addTarget(self, action: #selector(settingsCategory), for: .touchUpInside)
        return settingsCategoryButton
    }()

    private lazy var noteTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Note"
        label.textColor  = Color.inputFG
        label.backgroundColor = Color.controlBG
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Color.controlBG
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textColor  = Color.inputFG
        textField.addTarget(self, action: #selector(noteTextFieldChanged), for: .editingChanged)
        return textField
    }()

    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            amountTextFieldLabel, amountTextField
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = Color.controlBG
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2,
                                                                 leading: 5,
                                                                 bottom: 2,
                                                                 trailing: 2)
        stackView.spacing = 5
        return stackView
    }()

    private lazy var defaultView: UIView = {
        let defaultView = UIView()
        return defaultView
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            dateTextFieldLabel, picker, defaultView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.backgroundColor = Color.controlBG
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2,
                                                                 leading: 5,
                                                                 bottom: 2,
                                                                 trailing: 2)
        return stackView
    }()

    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            categoryTextFieldLabel, settingsCategoryButton, UIView()
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.backgroundColor = Color.controlBG
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2,
                                                                 leading: 5,
                                                                 bottom: 2,
                                                                 trailing: 2)
        return stackView
    }()

    private lazy var noteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            noteTextFieldLabel, noteTextField
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.backgroundColor = Color.controlBG
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2,
                                                                 leading: 5,
                                                                 bottom: 2,
                                                                 trailing: 2)
        return stackView
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    func reloadRecord(inputRecord: Record?) {
        childrenRecord = CoreDataManager.shared.findRecord(viewContext: childrenViewContext, record: inputRecord!)
        noteTextField.text = childrenRecord?.note
        amountTextField.text = String((childrenRecord?.amount)!)
        settingsCategoryButton.setImage(UIImage(systemName: (childrenRecord?.category?.imageName)!), for: .normal)
        settingsCategoryButton.setTitle((childrenRecord?.category?.lableName)!, for: .normal)
        picker.date = (childrenRecord?.creationDate)!
        let coordinate = CLLocationCoordinate2D(latitude: (childrenRecord?.latitudeCoordinate)!,
                                                longitude: (childrenRecord?.longitudeCoordinate)!)
        let annotation = MapPin(coordinate: coordinate, title: (childrenRecord?.note)!)
        mapView.removeAnnotations(annotations)
        mapView.addAnnotation(annotation)
        annotations.append(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }

    @objc func noteTextFieldChanged() {
        childrenRecord?.note = noteTextField.text!
    }

    @objc func amountTextFieldChanged() {
        childrenRecord?.amount = Int64((amountTextField.text)!)!
    }

    @objc func datePickerChanged() {
        childrenRecord?.creationDate = picker.date
    }

    @objc func saveButtonAction() throws {
        try CoreDataManager.shared.savePrivateContext(childrenViewContext)
        navigationController?.popViewController(animated: true)
    }

    @objc func settingsCategory() {
        let categoryViewController = CategoriesViewController()
        categoryViewController.delegate = self
        self.present(categoryViewController, animated: true)
    }

     func createGestureRecognizer() {
         let longTap = UILongPressGestureRecognizer(target: self, action: #selector(actionLongTap))
         mapView.addGestureRecognizer(longTap)
     }

     @objc func actionLongTap (tap: UILongPressGestureRecognizer) {
         let point = tap.location(in: mapView)
         let convert = mapView.convert(point, toCoordinateFrom: mapView)
         let coordinate = CLLocationCoordinate2D(latitude: convert.latitude, longitude: convert.longitude)
         self.coordinate = coordinate
         let annotation = MapPin(coordinate: coordinate, title: noteTextField.text!)
         mapView.removeAnnotations(annotations)
         mapView.addAnnotation(annotation)
         annotations.append(annotation)
         mapView.showAnnotations([annotation], animated: true)
         childrenRecord?.latitudeCoordinate = coordinate.latitude
         childrenRecord?.longitudeCoordinate = coordinate.longitude
     }

    func setConstraints() {
        view.addSubview(mapView)
        view.addSubview(amountStackView)
        view.addSubview(dateStackView)
        view.addSubview(categoryStackView)
        view.addSubview(noteStackView)

        NSLayoutConstraint.activate([
            amountStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Default.zero),
            amountStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Default.zero),
            amountStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.zero),
            amountStackView.heightAnchor.constraint(equalToConstant: Default.StackViewHeight),
            amountTextFieldLabel.widthAnchor.constraint(equalToConstant: Default.LabelWidth),

            dateStackView.topAnchor.constraint(equalTo: amountStackView.bottomAnchor, constant: Default.zero),
            dateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Default.zero),
            dateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.zero),
            dateStackView.heightAnchor.constraint(equalToConstant: Default.StackViewHeight),
            dateTextFieldLabel.widthAnchor.constraint(equalToConstant: Default.textFieldWidth),

            categoryStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: Default.zero),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Default.zero),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.zero),
            categoryStackView.heightAnchor.constraint(equalToConstant: Default.StackViewHeight),
            categoryTextFieldLabel.widthAnchor.constraint(equalToConstant: Default.LabelWidth),

            noteStackView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: Default.zero),
            noteStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Default.zero),
            noteStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.zero),
            noteStackView.heightAnchor.constraint(equalToConstant: Default.StackViewHeight),
            noteTextFieldLabel.widthAnchor.constraint(equalToConstant: Default.LabelWidth),

        mapView.topAnchor.constraint(equalTo: noteStackView.bottomAnchor, constant: Default.zero),
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Default.zero),
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Default.zero),
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Default.zero),
            defaultView.widthAnchor.constraint(equalToConstant: Default.defaultViewWidth)
        ])
        defaultView.contentHuggingPriority(for: .horizontal)
        defaultView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        picker.contentHuggingPriority(for: .horizontal)
    }
}

extension SettingsRecordViewController: CategoriesViewControllerDelegate {
    func categoryWasSelected(category: Category) {
        let selectedCategory = CoreDataManager.shared.findCategory(viewContext: childrenViewContext, object: category)
                childrenRecord?.category = selectedCategory
        settingsCategoryButton.setImage(UIImage(systemName: (childrenRecord?.category!.imageName)!), for: .normal)
        settingsCategoryButton.setTitle((childrenRecord?.category!.lableName)!, for: .normal)
    }
}

extension SettingsRecordViewController: UIGestureRecognizerDelegate, CLLocationManagerDelegate {
}

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

// MARK: - Constants

extension SettingsRecordViewController {
    enum Default {
        static let defaultViewWidth: CGFloat = 115
        static let zero: CGFloat = 0
        static let StackViewHeight: CGFloat = 50
        static let LabelWidth: CGFloat = 80
        static let textFieldWidth: CGFloat = 60
    }
}
