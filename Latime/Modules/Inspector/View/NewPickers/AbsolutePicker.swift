//
//  AbsolutePicker.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class AbsoluteDatePickerViewController: UIViewController {
    
    struct Sizes {
    
        static let corner: CGFloat = 0.0
        static let borderWidth: CGFloat = 0.0
        
        static let topOffset: CGFloat = 0
        static let btmOffset: CGFloat = 0
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = -15
        static let widthOffset: CGFloat = -(leadingOffset + (-trailingOffset))
        static let spacer: CGFloat = 8
    
    }
    
    let identifier: String = "AbsolutePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// views
    private lazy var titleStackView: UIStackView = UIStackView()
    private lazy var datePicker: UIDatePicker = UIDatePicker()
    private let countdown = InspectorCountdownView()
    private let scrollView = UIScrollView()

    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        scrollView.scrollRectToVisible(countdown.frame, animated: true)
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
        setupDatePicker(datePicker)
        setupCountdown()
        setupScrollView(scrollView)
        setupSelf()

        setupConstraints()
    }
    
    func setupScrollView(_ scrollView: UIScrollView) {
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(countdown)
        scrollView.addSubview(datePicker)
    }
    
    private func setupDatePicker(_ picker: UIDatePicker) {
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .inline
        picker.minuteInterval = 5
        picker.date = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.tintColor = UIColor.myAccent
        
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        picker.minimumDate = referenceDate
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: 100, to: referenceDate)
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
        // updateDateInterval(datePicker.date)
    }
    
    func setupCountdown() {
        countdown.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSelf() {
        view.backgroundColor = UIColor.myViewBackground
    }
    
    func setupConstraints() {
        let sa = view.safeAreaLayoutGuide
        
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: sa.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: sa.bottomAnchor),
        
            datePicker.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Sizes.leadingOffset),
            datePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Sizes.trailingOffset),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, constant: Sizes.widthOffset),
            
            countdown.topAnchor.constraint(equalToSystemSpacingBelow: datePicker.bottomAnchor, multiplier: 3 ),
            countdown.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            countdown.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
            countdown.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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

