//
//  plateView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class CountdownInput: UIView {
    
    // MARK: Sizes
    private struct Sizes {
        static let corner: CGFloat = 10.0
        static let textFieldCorner: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let textFieldInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 0)
        
        static let topAnchorOffset: CGFloat = 10.0
        static let btmAnchorOffset: CGFloat = 30.0
        static let leadingAnchorOffset: CGFloat = 0.0
        static let trailingAnchorOffset: CGFloat = 0.0
        
        static let verticalSpacing: CGFloat = 8
    }
    
    private var stackView = UIStackView()
    
    let daysCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let hoursCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let minutesCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    
    private let daysTitle = UILabel()
    private let hoursTitle = UILabel()
    private let minutesTitle = UILabel()
    
    // MARK: configure
    private var inputText = ""
    //private var notChangedYet = true
    private var changeNumber = 0
    
    func configure() {
        daysTitle.text = "days"
        hoursTitle.text = "hrs"
        minutesTitle.text = "mins"
        daysCounter.text = "0"
        hoursCounter.text = "14"
        minutesCounter.text = "30"
        
        hoursCounter.maxValue = 47
        minutesCounter.maxValue = 59
    }
    
    // FIXME: bad implementation
    func setupViews() {
        setupViewsPrivate()
    }
    
    func dayStarted() {
        daysCounter.layer.borderColor = UIColor.black.cgColor
    }
    
    func dayFinished() {
        daysCounter.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func setDayLabel(_ text: Int) {
        self.daysCounter.text = String((text))
    }
}

// MARK: - Setup views

private extension CountdownInput {
    
    func setupViewsPrivate() {
        
        configure()
        
        setupSelf()
        setupTextField(daysCounter)
        setupTextField(hoursCounter)
        setupTextField(minutesCounter)
        setupTitle(daysTitle)
        setupTitle(hoursTitle)
        setupTitle(minutesTitle)
        setupStackView(stackView)
        
        setupConstarints()
        
        
    }
    
    func setupTextField(_ tf: UITextField) {
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        // View
        tf.backgroundColor = UIColor(white: 0.93, alpha: 1)
        tf.layer.cornerRadius = Sizes.textFieldCorner
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.masksToBounds = true
        // Text
        tf.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .regular)
        tf.keyboardType = .numberPad
        tf.tintColor = .clear
    }
    
    func setupTitle(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
    }
    
    func setupStackView(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        stack.alignment = .firstBaseline
        stack.spacing = 2
        addSubview(stack)
        setupStackSubviews(stack)
    }
    
    func setupStackSubviews(_ stack: UIStackView) {
        stack.addArrangedSubview(daysCounter)
        stack.addArrangedSubview(daysTitle)
        stack.addArrangedSubview(hoursCounter)
        stack.addArrangedSubview(hoursTitle)
        stack.addArrangedSubview(minutesCounter)
        stack.addArrangedSubview(minutesTitle)
        
        stack.setCustomSpacing(15, after: daysTitle)
    }
    
    func setupSelf() {
        self.backgroundColor = .white
        
        self.layer.cornerRadius = Sizes.corner
    }
    
    
    func setupConstarints() {
        let sa = self.safeAreaLayoutGuide
        let constraints = [
            stackView.topAnchor.constraint(equalTo: sa.topAnchor, constant: Sizes.topAnchorOffset),
            stackView.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: Sizes.leadingAnchorOffset),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: Sizes.trailingAnchorOffset),
            
            sa.bottomAnchor.constraint(equalTo: daysTitle.lastBaselineAnchor, constant: Sizes.btmAnchorOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
}

extension CountdownInput: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: fix this color
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    // TODO: refactor textFieldShouldChange
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        if let ptf = textField as? PaddingTextField, let max = ptf.maxValue {
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
            } else{
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeNumber = 0
        
        textField.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
}


