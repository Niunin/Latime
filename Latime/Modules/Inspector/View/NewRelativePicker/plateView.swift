//
//  plateView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

public class TimeDifferenceView: UIView {
    
    private let desctiptionLabel = UILabel()
    private var stackView = UIStackView()
    
    private let daysCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let hoursCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let minutesCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    
    private let daysTitle = UILabel()
    private let hoursTitle = UILabel()
    private let minutesTitle = UILabel()
        
    // MARK: configure
    
    func configure() {
        daysTitle.text = "days"
        hoursTitle.text = "h"
        minutesTitle.text = "m"
        daysCounter.text = "2"
        minutesCounter.text = "14"
        hoursCounter.text = "30"
    }
    
    // MARK: Sizes
    struct Sizes {
        static let stroke: CGFloat = 2.0
        static let corner: CGFloat = 5.0
        static let textFieldInsets = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 0)
    }
    
    func dayStarted() {
            daysCounter.layer.borderColor = UIColor.systemTeal.cgColor
//            daysCounter.layer.borderWidth = 2
            daysCounter.textColor = UIColor.systemTeal
    }
    
    func dayFinished() {
        daysCounter.layer.borderColor = UIColor.black.cgColor
//        daysCounter.layer.borderWidth = 1
        daysCounter.textColor = UIColor.myAccent
    }
    
    func setDayLabel(_ text: Int) {
        self.daysCounter.text = String((text))
    }

}

// MARK: - Setup views

private extension TimeDifferenceView {
    
    public func setupViews() {
        
        configure()
        
        setupDescription(desctiptionLabel)
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
    
    func setupDescription(_ label: UILabel) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupTextField(_ tf: UITextField) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = Sizes.corner
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
    }
    
    func setupTitle(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        stack.setCustomSpacing(8, after: daysTitle)
        stack.setCustomSpacing(8, after: hoursTitle)
        stack.setCustomSpacing(8, after: minutesTitle)
    }
    
    func setupConstarints() {
        let sa = self.safeAreaLayoutGuide
        let constraints = [
            desctiptionLabel.topAnchor.constraint(equalTo: sa.topAnchor, constant: 10),
            desctiptionLabel.leadingAnchor.constraint(equalTo: sa.leadingAnchor,  constant: 20),
            desctiptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: desctiptionLabel.lastBaselineAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: -10)
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

