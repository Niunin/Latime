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
    
    weak var delegate: InspectorDatePickerDelegate!
    
    // TODO: rename
    private var changeNumber = 0
    
    /// views
    private let stack = UIStackView()
    private let dayField = InputDateField()
    private let hourField = InputDateField()
    private let minutesField = InputDateField()
    
    private let link = UIView()
    
    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: methods
    
    @IBAction private func dateChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
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
    
    func setupDayField() {
        dayField.configureDescription("days")
        dayField.delegate = self
    }
    
    func setupHourField() {
        hourField.configureDescription("hours")
        hourField.setMaxValue(23)
        hourField.delegate = self
    }
    
    func setupMinuteField() {
        minutesField.configureDescription("minutes")
        minutesField.setMaxValue(59)
        minutesField.delegate = self
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
        
        let constraints = [
            stack.topAnchor.constraint(equalTo: sa.topAnchor),
            stack.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: mg.trailingAnchor ),
            
            link.leadingAnchor.constraint(equalTo: hourField.textField.leadingAnchor),
            link.trailingAnchor.constraint(equalTo: hourField.textField.trailingAnchor),
            link.topAnchor.constraint(equalTo: hourField.textField.centerYAnchor),
            link.bottomAnchor.constraint(equalTo: minutesField.textField.centerYAnchor),
            
            mg.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: - InspectorDatePicker Protocol

extension RelativeDateInput: InspectorDatePickerProtocol {
    
    func setDate(_ date: Date) {
        
    }
    
}

// MARK: UITextField Delegate

extension RelativeDateInput: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: fix this color
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    // TODO: refactor textFieldShouldChange
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let ptf = textField as? LimitedTextField, let max = ptf.maxValue {
            var currentText = textField.text ?? ""
            // TODO: rename these vars
            if string == "" {
                currentText.removeLast()
                if currentText == "" {
                    currentText = "00"
                    changeNumber = 0
                } else {
                    currentText = "0" + currentText
                    changeNumber = 1
                }
                textField.text = currentText
            } else {
                switch changeNumber {
                case 1:
                    let firstSign = currentText.last!
                    let newString = String(firstSign) + string
                    if Int(String(newString))! > max {
                        textField.text = "0" + string
                        changeNumber = 1
                    } else {
                        textField.text = newString
                        changeNumber = 0
                    }
                default:
                    textField.text = "0" + string
                    changeNumber = 1
                }
            }
        } else {
            var currentString = textField.text ?? ""
            if string == "" {
                currentString.removeLast()
                textField.text = currentString
            } else {
                textField.text = currentString + string
            }
            if textField.text?.first == "0" {
                textField.text?.removeFirst()
            }
            if textField.text == "" {
                textField.text = "0"
            }
        }
        return false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        changeNumber = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
}




