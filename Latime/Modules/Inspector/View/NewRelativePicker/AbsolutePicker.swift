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
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        plate.setupViews()

    }
    
}

// MARK: - Setup Views

private extension AbsoluteDatePickerViewController {
    
    func setupViews() {
        setupDatePicker()
        setupPlate()
        setupSelf()

        setupConstraints()
    }
    
    
    func updateDateInterval(_ date: Date) {
        
//        UIView.transition(with: intervalLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
//            let start = Date()
//            self.intervalLabel.text =
//        },
//        completion: nil)
    }
    
    func setupDatePicker() {
        
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
            
            
            
        
            
        
    }
    
    func setupPlate() {
        view.addSubview(plate)
        plate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSelf() {
        view.backgroundColor = .myViewBackground
    }
    
    func setupConstraints() {
        let sa = view.safeAreaLayoutGuide
        
        let constraints = [
            plate.topAnchor.constraint(equalTo: sa.topAnchor, constant: 30),
            plate.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 8),
            plate.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -8),
            plate.heightAnchor.constraint(equalToConstant: 70),
            
            datePicker.leadingAnchor.constraint(equalTo: plate.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: plate.trailingAnchor),
            datePicker.topAnchor.constraint(
                equalToSystemSpacingBelow:
                    plate.safeAreaLayoutGuide.bottomAnchor, multiplier: 2
            ),
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

