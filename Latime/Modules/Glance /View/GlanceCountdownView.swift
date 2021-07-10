//
//  GlanceCountdownView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

//MARK: - Object

class GlanceCountdownView: UIView {
    
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
            countdown2.text = "• " + array2.first!
            countdownUnits2.text = array2.last!
        }
        
        if let array3 = c3?.components(separatedBy: " ") {
            countdown3.text = "• " + array3.first!
            countdownUnits3.text = array3.last!
        }
    }

}

// MARK: - Setup Views

private extension GlanceCountdownView {
    
    private func setupViews() {
        setupCountdown(countdown1)
        setupCountdown(countdown2)
        setupCountdown(countdown3)
        setupCountdownUnits(countdownUnits1)
        setupCountdownUnits(countdownUnits2)
        setupCountdownUnits(countdownUnits3)
        setupStackView(stack)

        self.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        
        countdown1.font = UIFont.F0
        
        countdown1.text = "6"
        countdown2.text = "12"
        countdown3.text = "30"
        countdownUnits1.text = "days"
        countdownUnits2.text = "hrs"
        countdownUnits3.text = "mins"
        
        setupConstraints()
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
        label.font = UIFont.F3
    }
    
    private func setupCountdownUnits(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.font = UIFont.F3
    }
    
    private func setupConstraints() {
        //let lmg = self.layoutMarginsGuide
        
        let constraints =  [
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
        //    bottomAnchor.constraint(equalTo: stack.bottomAnchor),
          //  trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
        heightAnchor.constraint(greaterThanOrEqualTo: stack.heightAnchor).isActive = true
    }
    
}

