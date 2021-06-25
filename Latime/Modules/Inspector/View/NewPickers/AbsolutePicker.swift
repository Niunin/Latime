//
//  AbsolutePicker.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class AbsoluteDatePickerViewController: UIViewController {
    
    let identifier: String = "AbsolutePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// views
    private lazy var titleStackView: UIStackView = UIStackView()
    private lazy var datePicker = datePickerPlate()
    private let plate = TimeDifferenceView()
    private let scrollView = UIScrollView()

    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        plate.setupViews()
        plate.setupSpecial()
        notificationsListener()
    }
    
    func notificationsListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }

    @IBAction func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        print(scrollView.contentSize)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0)
        scrollView.contentInset = contentInsets
//        scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        scrollView.scrollRectToVisible(plate.frame, animated: true)
    }

    @IBAction func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -keyboardSize.height,
            right: 0)
        scrollView.contentInset = contentInsets
        self.view.endEditing(true)
    }
    
}

// MARK: - Setup Views

private extension AbsoluteDatePickerViewController {
    
    func setupViews() {
        setupDatePicker()
        setupPlate()
        setupScrollView(scrollView)
        setupSelf()

        setupConstraints()
    }
    
    func setupScrollView(_ scrollView: UIScrollView) {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(plate)
        scrollView.addSubview(datePicker)
    }
    
    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupPlate() {
        plate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSelf() {
        view.backgroundColor = UIColor.specGray
        datePicker.backgroundColor = .white
    }
    
    func setupConstraints() {
        let sa = view.safeAreaLayoutGuide
        
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: sa.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: sa.bottomAnchor),
        
            datePicker.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16),
            
            plate.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            plate.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5),
            plate.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
            plate.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: - InspectorDatePicker Protocol

extension AbsoluteDatePickerViewController: InspectorDatePickerProtocol {
    
    func setDate(_ date: Date) {
        //datePicker.date = date
    }
    
}

