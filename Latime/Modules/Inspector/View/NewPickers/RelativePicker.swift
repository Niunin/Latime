//
//  RelativePicker2.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class RelativeDatePickerViewController: UIViewController {
    
    struct Sizes {
        
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 0
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = -15
        static let centerOffset: CGFloat = 15
        static let widthOffset: CGFloat = -(leadingOffset + (-trailingOffset))
        static let spacer: CGFloat = 8
        
        static let titleSpacingBefore: CGFloat = 40
        static let titleSpacingAfter: CGFloat = 5
        
    }
    
    
    let identifier: String = "RelativePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// old views
    private var rotor: RotorScaleView!
    
    /// views
    private let plateTitleLabel = UILabel()
    private let pre = TimePointView()
    private let post = TimePointView()
    private let plate = CountdownInput()
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        // FIXME: Wrong calling place
        plate.setupViews()
    }

    // MARK: actions
    
    @IBAction private func dateChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
    }

}

// MARK: - Setup Views

private extension RelativeDatePickerViewController {
    
    func setupViews() {
        setupSelf()
        setupPlateTitle(plateTitleLabel)
        setupPlates()
        setupRotor()
    }
    
    func setupSelf() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(pre)
        view.addSubview(post)
        view.addSubview(plateTitleLabel)
        view.addSubview(plate)
    }
    
    func setupPlateTitle(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time difference"
        label.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setupPlates() {
        pre.translatesAutoresizingMaskIntoConstraints = false
        post.translatesAutoresizingMaskIntoConstraints = false
        plate.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRotor() {
        self.rotor = RotorScaleView(frame: view.bounds)
        view.addSubview(rotor)
        rotor.delegate = self
        rotor.setupSelf()
    }

    func setupConstraints() {
        let sa = view.safeAreaLayoutGuide
        
        let constraints = [
            pre.topAnchor.constraint(equalTo: sa.topAnchor, constant: Sizes.topOffset),
            pre.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: Sizes.leadingOffset),
            pre.trailingAnchor.constraint(equalTo: sa.centerXAnchor, constant: -Sizes.centerOffset),
            
            post.topAnchor.constraint(equalTo: pre.topAnchor),
            post.leadingAnchor.constraint(equalTo: sa.centerXAnchor, constant: Sizes.centerOffset),
            post.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: Sizes.trailingOffset),

            plateTitleLabel.topAnchor.constraint(equalTo: pre.bottomAnchor, constant: Sizes.titleSpacingBefore),
            plateTitleLabel.leadingAnchor.constraint(equalTo: pre.leadingAnchor),
            plateTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: post.trailingAnchor),
            
            plate.topAnchor.constraint(equalTo: plateTitleLabel.bottomAnchor, constant: Sizes.titleSpacingAfter),
            plate.leadingAnchor.constraint(equalTo: pre.leadingAnchor),
            plate.trailingAnchor.constraint(equalTo: post.trailingAnchor),
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


