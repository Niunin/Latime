//
//  RelativePicker2.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class RelativeDatePickerViewController: UIViewController {
    
    let identifier: String = "RelativePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// old views
    private var rotor: RotorScaleView!
    
    /// views
    private let plate = TimeDifferenceView()
    private let pre = TimePointView()
    private let post = TimePointView()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        plate.setupViews()
    }

    // MARK: actions
    
    @IBAction private func dateChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
    }

}

private extension RelativeDatePickerViewController {
    // MARK: setup views
    
    func setupViews() {
        setupSelf()
        setupRotor()
    }
    
    func setupRotor() {
        self.rotor = RotorScaleView(frame: view.bounds)
        view.addSubview(rotor)
        rotor.delegate = self
        rotor.setupSelf()
        
        view.addSubview(plate)
        view.addSubview(pre)
        view.addSubview(post)
        
//        post.backgroundColor = .brown
        pre.translatesAutoresizingMaskIntoConstraints = false
        post.translatesAutoresizingMaskIntoConstraints = false
        plate.translatesAutoresizingMaskIntoConstraints = false
    }
        
    func setupSelf() {
        view.backgroundColor = .myViewBackground
    }
    
    func setupConstraints() {
        let sa = view.safeAreaLayoutGuide
        let constraints = [
            pre.topAnchor.constraint(equalTo: sa.topAnchor, constant: 20),
            pre.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 15),
            pre.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -8),
            pre.heightAnchor.constraint(equalToConstant: 50),

            plate.topAnchor.constraint(equalTo: pre.bottomAnchor, constant: 20),
            plate.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 8),
            plate.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -8),
            plate.heightAnchor.constraint(equalToConstant: 70),
            
            
            post.topAnchor.constraint(equalTo: plate.bottomAnchor, constant: 20),
            post.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 15),
            post.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -8),
            post.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: - RotorScale Delegate

extension RelativeDatePickerViewController: RotorScaleDelegate {
    
    func scaleAppeared() {
        plate.dayStarted()
    }
    
    func scaleDisappeared() {
        plate.dayFinished()
    }
    
    func valueChanged(to value: Int) {
        plate.setDayLabel(value)
    }
    
}

// MARK: - InspectorDatePicker Protocol

extension RelativeDatePickerViewController: InspectorDatePickerProtocol {
    
    func setDate(_ date: Date) {
        
    }

}


