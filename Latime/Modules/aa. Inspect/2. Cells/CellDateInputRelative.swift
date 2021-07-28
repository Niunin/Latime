//
//  CellInput.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit

// MARK: - Object

class RelativeDateInput: UICollectionViewCell {
    
    struct Sizes {
        
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 0
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = -15
        static let centerOffset: CGFloat = 15
        static let widthOffset: CGFloat = -(leadingOffset + abs(trailingOffset))
        static let spacer: CGFloat = 8
        
        static let titleSpacingBefore: CGFloat = 40
        static let titleSpacingAfter: CGFloat = 5
        
    }
    
    static let reuseIdentifier = "rel-cell-reuse-identifier"
    
    // MARK: properties
    
    /// Hierarchy
    var handler: ((_: TimeInterval)->())?
    
    /// views
    private let stack = UIStackView()
    private let dayField = InputDateField()
    private let hourField = InputDateField()
    private let minutesField = InputDateField()
    
    private let link = UIView()
    
    var hour: Int = 0
    var min: Int = 0
    var days: Int = 0
    
    
    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: date input protocol conformance
    
    func setDate(_ date: Date) {
        
    }
    
    func setTimeInterval(_ interval: TimeInterval) {
        print("___\( interval)")
        let days: Int = Int(interval) / (86400)
        let hours: Int = (Int(interval) % (86400)) / 3600
        let minutes: Int = ((Int(interval) % (86400)) % (3600)) / 60
        
        dayField.textField.text = "\(days)"
        hourField.textField.text = "\(hours)"
        minutesField.textField.text = "\(minutes)"
    }
    
}

// MARK: - Setup Views

private extension RelativeDateInput {
    
    func setupViews() {
        setupSelf()
        
        setupDayField()
        setupHourField()
        setupMinuteField()
        setupStack(stack)
        setupLink()
        
        setupConstraints()
    }
    
    func setupSelf() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(link)
        contentView.addSubview(stack)
    }
    
    func handlerMake() -> (() -> ()) {
        return { [weak self] in
            guard let self = self else {return}
            let secondsInMinutes: Int = 60 * self.minutesField.result
            let secondsInHours: Int = 3600 * self.hourField.result
            let secondsInDays:  Int = 3600 * 24 * self.dayField.result
            
            let interval: TimeInterval = TimeInterval(secondsInMinutes + secondsInHours + secondsInDays)
            self.handler?(interval)
        }
    }
    
    func setupDayField() {
        dayField.configureDescription("days")
        dayField.updateHandler = handlerMake()
    }
    
    func setupHourField() {
        hourField.configureDescription("hours")
        hourField.setMaxValue(23)
        hourField.updateHandler = handlerMake()
    }
    
    func setupMinuteField() {
        minutesField.configureDescription("minutes")
        minutesField.setMaxValue(59)
        minutesField.updateHandler = handlerMake()
    }
    
    func setupStack(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        
        stack.addArrangedSubview(dayField)
        stack.addArrangedSubview(hourField)
        stack.addArrangedSubview(minutesField)
    }
    
    func setupLink() {
        link.backgroundColor = UIColor.mg1
    }
    
    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        link.translatesAutoresizingMaskIntoConstraints = false
        
        let sa = contentView.safeAreaLayoutGuide
        let mg = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: sa.topAnchor),
            stack.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: mg.trailingAnchor ),
            
            link.leadingAnchor.constraint(equalTo: hourField.textField.leadingAnchor),
            link.trailingAnchor.constraint(equalTo: hourField.textField.trailingAnchor),
            link.topAnchor.constraint(equalTo: hourField.textField.centerYAnchor),
            link.bottomAnchor.constraint(equalTo: minutesField.textField.centerYAnchor),
            
            mg.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
        ])
    }
}

