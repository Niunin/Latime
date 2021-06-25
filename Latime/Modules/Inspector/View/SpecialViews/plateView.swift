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
    
    let daysCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let hoursCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let minutesCounter = PaddingTextField(withInsets: Sizes.textFieldInsets)
    
    private let daysTitle = UILabel()
    private let hoursTitle = UILabel()
    private let minutesTitle = UILabel()
        
    // MARK: configure
    
    func configure() {
        daysTitle.text = "days"
        hoursTitle.text = ":"
        minutesTitle.text = ""
        daysCounter.text = "2"
        minutesCounter.text = "14"
        hoursCounter.text = "30"
    }
    
    // MARK: Sizes
    struct Sizes {
        static let corner: CGFloat = 15.0
        static let textFieldCorner: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let textFieldInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 0)
        
        static let topAnchorOffset: CGFloat = 10.0
        static let btmAnchorOffset: CGFloat = 30.0
        static let leadingAnchorOffset: CGFloat = 20.0
        static let trailingAnchorOffset: CGFloat = -20.0
        
        static let verticalSpacing: CGFloat = 8
        static let descriptionIndent: CGFloat = 10
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

    func setupSpecial() {
        setupConstarints2()
        
        self.layer.shadowRadius = 0
        self.layer.borderWidth = 0
        self.backgroundColor = UIColor.specGray
        
        daysCounter.backgroundColor = .white
        hoursCounter.backgroundColor = .white
        minutesCounter.backgroundColor = .white
    }
    
    func setupNuew() {
        setupConstarints()

        
        self.layer.shadowRadius = 0
        self.layer.borderWidth = 0
        self.backgroundColor = UIColor.specGray
        daysCounter.backgroundColor = .white
        hoursCounter.backgroundColor = .white
        minutesCounter.backgroundColor = .white
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
//        setupConstarints()
    }
    
    func setupDescription(_ label: UILabel) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time difference"
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupTextField(_ tf: UITextField) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .systemGray5
        tf.layer.cornerRadius = Sizes.textFieldCorner
        //tf.layer.borderColor = UIColor.systemGray5.cgColor
        //tf.layer.borderWidth = 1.5
        tf.layer.masksToBounds = true
        tf.font = UIFont.systemFont(ofSize: 22)
        tf.keyboardType = .numberPad
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
        self.layer.borderColor = UIColor.systemGray5.cgColor
        
        self.layer.cornerRadius = Sizes.corner
        self.layer.borderWidth = Sizes.borderWidth
        
        self.layer.shadowRadius = 6
        self.layer.shadowColor = UIColor.systemGray3.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
        
    func setupConstarints() {
        let sa = self.safeAreaLayoutGuide
        let constraints = [
            desctiptionLabel.topAnchor.constraint(equalTo: sa.topAnchor, constant: Sizes.topAnchorOffset),
            desctiptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,  constant: Sizes.descriptionIndent),
            desctiptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: desctiptionLabel.lastBaselineAnchor, constant: Sizes.verticalSpacing),
            stackView.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: Sizes.leadingAnchorOffset),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: Sizes.trailingAnchorOffset),
            
            sa.bottomAnchor.constraint(equalTo: daysTitle.lastBaselineAnchor, constant: Sizes.btmAnchorOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    
    func setupConstarints2() {
        let sa = self.safeAreaLayoutGuide
        
        let constraints = [
            desctiptionLabel.topAnchor.constraint(equalTo: sa.topAnchor, constant: Sizes.topAnchorOffset),
            desctiptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,  constant: Sizes.descriptionIndent),
            desctiptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: desctiptionLabel.lastBaselineAnchor, constant: Sizes.verticalSpacing),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: sa.leadingAnchor, constant: Sizes.leadingAnchorOffset),
            stackView.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: Sizes.trailingAnchorOffset),
            
            sa.bottomAnchor.constraint(equalTo: daysTitle.lastBaselineAnchor, constant: Sizes.btmAnchorOffset)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}


