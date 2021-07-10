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
    
    // MARK: properties
    
    let identifier: String = "AbsolutePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// views
    private let stack = UIStackView()
    private var datePicker: UIDatePicker = UIDatePicker()
    private let countdownInfo = InfoCountdownView()

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
        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollRectToVisible(countdownInfo.frame, animated: true)
    }

    @IBAction func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -keyboardSize.height,
            right: 0)
//        scrollView.contentInset = contentInsets
        self.view.endEditing(true)
    }
    
}

// MARK: - Setup Views

private extension AbsoluteDatePickerViewController {
    
    func setupViews() {
        setupSelf()
        
        setupStack(stack)
        setupDatePicker(datePicker)

        setupConstraints()
    }
    
    func setupSelf() {
        view.backgroundColor = UIColor.myViewBackground
        view.addSubview(stack)
    }
    
    func setupStack(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        
        stack.addArrangedSubview(countdownInfo)
        stack.addArrangedSubview(datePicker)
        
        stack.setCustomSpacing(30, after: countdownInfo)
    }
    
    private func setupDatePicker(_ picker: UIDatePicker) {
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
    }
    
    func setupConstraints() {
        // scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let sa = view.safeAreaLayoutGuide
        
        let constraints = [
            stack.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            stack.topAnchor.constraint(equalTo: sa.topAnchor),
            stack.bottomAnchor.constraint(equalTo: sa.bottomAnchor),
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

