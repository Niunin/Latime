//
//  plateDatePicker.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

// TODO: Make it inherit UIDatePicker
public class datePickerPlate: UIView {
    
    private lazy var datePicker: UIDatePicker = UIDatePicker()
    
    // MARK: configure
    
    func configure() {

    }
    
    // MARK: Sizes
    struct Sizes {
        static let stroke: CGFloat = 2.0
        static let corner: CGFloat = 5.0
        static let textFieldInsets = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 0)
    }
    
    public override func didMoveToSuperview() {
        setupViews()
    }

}

// MARK: - Setup views

private extension datePickerPlate {
    
    public func setupViews() {
        setupDatePicker(datePicker)
        setupSelf()
        setupConstarints()
    }
    
    func setupDatePicker(_ picker: UIDatePicker) {
        addSubview(picker)
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
//        delegate.dateChanged(sender.date)
//        updateDateInterval(datePicker.date)
    }
    
    func setupConstarints() {
        let sa = self.safeAreaLayoutGuide
        
        let constraints = [
            datePicker.topAnchor.constraint(equalTo: sa.topAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: sa.leadingAnchor,  constant: 20),
            datePicker.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: -10),
            
            sa.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSelf() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Sizes.corner
        self.layer.borderColor = UIColor.systemGray5.cgColor
        
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        
        
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.systemGray3.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}


