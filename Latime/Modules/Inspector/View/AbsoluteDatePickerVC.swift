//
//  RelVC.swift
//  iX-33
//
//  Created by Andrea Nunti on 15.04.2021.
//

import UIKit


// MARK: - Object

class AbsoluteDatePickerViewController: UIViewController {
    
    let identifier: String = "AbsolutePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// views
    private lazy var titleStackView: UIStackView = UIStackView()
    private lazy var datePicker: UIDatePicker = UIDatePicker()
    private lazy var intervalLabel = PaddingLabel(withInsets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: setup views
    
    private func setupViews() {
        setupIntervalLabel(intervalLabel)
        setupDatePicker(datePicker)
        setupSelf()
    }
    
    private func setupIntervalLabel(_ label: UILabel) {
        updateDateInterval(datePicker.date)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Visual
        label.textAlignment = .right
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        //label.textColor = .lightGray
        
        let corner: CGFloat = 5.0
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = corner
        label.layer.masksToBounds = true
        
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
    
    private func setupSelf() {
        view.backgroundColor = .myViewBackground
    }
    
    private func setupConstraints() {
        let constraints = [
            intervalLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            intervalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            intervalLabel.heightAnchor.constraint(equalToConstant: 30),
            intervalLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePicker.topAnchor.constraint(
                equalToSystemSpacingBelow:
                    intervalLabel.safeAreaLayoutGuide.bottomAnchor, multiplier: 1
            ),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: actions
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
        updateDateInterval(datePicker.date)
    }
    
    // MARK: helpers
    
    private func updateDateInterval(_ date: Date) {
        UIView.transition(with: intervalLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            let start = Date()
            self.intervalLabel.text = DateModel.fullDateDescription(from: start, to: date)
        },
        completion: nil)
    }
    
}

// MARK: - InspectorDatePicker Protocol

extension AbsoluteDatePickerViewController: InspectorDatePickerProtocol {
    
    func setDate(_ date: Date) {
        datePicker.date = date
    }
    
}
