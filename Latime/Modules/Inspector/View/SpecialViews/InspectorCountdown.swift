//
//  InspectorCountdown.swift
//  Latime
//
//  Created by Andrei Niunin on 29.06.2021.
//

import UIKit

//MARK: - Object

class InspectorCountdownView: UIView {
    
    // MARK: sizes data
    
    private struct Sizes {
    
        static let corner: CGFloat = 10.0
        
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
    
    }
    
    // MARK: properties
    
    private var countdown1 = UILabel()
    private var countdown2 = UILabel()
    private var countdown3 = UILabel()
    
    private lazy var countdownUnits1 = UILabel()
    private lazy var countdownUnits2 = UILabel()
    private lazy var countdownUnits3 = UILabel()
    
    private let stack = UIStackView()
 
    override var lastBaselineAnchor: NSLayoutYAxisAnchor {
        get {
            countdownUnits1.lastBaselineAnchor
        }
    }
    override var firstBaselineAnchor: NSLayoutYAxisAnchor {
        get {
            countdown1.firstBaselineAnchor
        }
    }
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    func configure(_ date: Date) {
        //let result = getDateDescription(from: Date(), to: date)
        let str = DateModel.fullDateDescription(from: Date(), to: date)
        let array = str.components(separatedBy: ", ")
        
        switch array.count {
        case 1:
            configure(c1: array[0])
        case 2:
            configure(c1: array[0], c2: array[1])
        default:
            configure(c1: array[0], c2: array[1], c3: array[2])
        }
    }
    
    private func configure(c1: String, c2: String? = nil, c3: String? = nil ) {
        let array1 = c1.components(separatedBy: " ")
        countdown1.text = array1.first!
        countdownUnits1.text = array1.last!
        
        if let array2 = c2?.components(separatedBy: " ") {
            countdown2.text = array2.first!
            countdownUnits2.text = array2.last!
        }
        
        if let array3 = c3?.components(separatedBy: " ") {
            countdown3.text = array3.first!
            countdownUnits3.text = array3.last!
        }
    }

}

// MARK: - Setup Views

private extension InspectorCountdownView {
    
    private func setupViews() {
        setupSelf()
        setupCountdown(countdown1)
        setupCountdown(countdown2)
        setupCountdown(countdown3)
        setupCountdownUnits(countdownUnits1)
        setupCountdownUnits(countdownUnits2)
        setupCountdownUnits(countdownUnits3)
        setupStackView(stack)

        self.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        countdown1.text = "6"
        countdown1.font = UIFont.init(name: "Futura-CondensedMedium", size: 38)
//        countdown1.font = UIFont.systemFont(ofSize: 38)
        
        countdown2.text = "12"
        countdown3.text = "30"
        countdownUnits1.text = "days"
        countdownUnits2.text = "hrs"
        countdownUnits3.text = "mins"
        
        setupConstraints()
    }
    
    func setupSelf() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = Sizes.corner
        self.clipsToBounds = true
    }
    
    func setupStackView(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        stack.alignment = .firstBaseline
        stack.spacing = 4
        addSubview(stack)
        
        stack.addArrangedSubview(countdown1)
        stack.addArrangedSubview(countdownUnits1)
        stack.addArrangedSubview(countdown2)
        stack.addArrangedSubview(countdownUnits2)
        stack.addArrangedSubview(countdown3)
        stack.addArrangedSubview(countdownUnits3)
        
        stack.setCustomSpacing(6, after: countdownUnits1)
        stack.setCustomSpacing(6, after: countdownUnits2)
    }
    
    private func setupCountdown(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.font = UIFont.init(name: "GillSans", size: 19)!
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .systemGray
    }
    
    private func setupCountdownUnits(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.font = UIFont.init(name: "GillSans", size: 14)!
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
    }
    
    private func setupConstraints() {
        let sa = self.safeAreaLayoutGuide
        
        let constraints =  [
            stack.topAnchor.constraint(equalTo: sa.topAnchor, constant: Sizes.topOffset),
            stack.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: Sizes.leadingOffset),
            sa.bottomAnchor.constraint(equalTo: stack.lastBaselineAnchor, constant: Sizes.btmOffset)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
