//
//  GlanceCountdownView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

//MARK: - Object

class CountdownView: UIView {
    
    private var countdown1 = UILabel()
    private var countdown2 = UILabel()
    private var countdown3 = UILabel()
    
    private lazy var countdownUnits1 = UILabel()
    private lazy var countdownUnits2 = UILabel()
    private lazy var countdownUnits3 = UILabel()
    
    private var guide12 = UILayoutGuide()
    private var guide23 = UILayoutGuide()
 
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

private extension CountdownView {
    
    func setupViews() {
        setupCountdown(countdown1)
        setupCountdown(countdown2)
        setupCountdown(countdown3)
        setupCountdownUnits(countdownUnits1)
        setupCountdownUnits(countdownUnits2)
        setupCountdownUnits(countdownUnits3)
        
        addLayoutGuide(guide12)
        addLayoutGuide(guide23)
        
        self.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        countdown1.text = "C1"
        countdown1.font = UIFont.init(name: "Futura-CondensedMedium", size: 32)
        countdown2.text = "C2"
        countdown3.text = "C3"
        
        setupConstraints()
    }
    
    func setupCountdown(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.font = UIFont.init(name: "Futura-CondensedMedium", size: 16)
        label.text = "C"
    }
    
    func setupCountdownUnits(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = "units"
        label.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupConstraints() {
        let sa = self.safeAreaLayoutGuide
        let space: CGFloat = 5
        
        let constraints = [
            countdown1.topAnchor.constraint(equalTo: sa.topAnchor),
            countdown1.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            countdownUnits1.topAnchor.constraint(equalTo: countdown1.lastBaselineAnchor, constant: 5),
            countdownUnits1.leadingAnchor.constraint(equalTo: countdown1.leadingAnchor),
            
            guide12.leadingAnchor.constraint(equalToSystemSpacingAfter: countdown1.trailingAnchor, multiplier: 1),
            guide12.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: countdownUnits1.trailingAnchor, multiplier: 1),
            guide12.widthAnchor.constraint(equalToConstant: space),
            
            countdown2.firstBaselineAnchor.constraint(equalTo: countdown1.firstBaselineAnchor),
            countdown2.leadingAnchor.constraint(equalTo: guide12.trailingAnchor),
            countdownUnits2.firstBaselineAnchor.constraint(equalTo: countdownUnits1.firstBaselineAnchor),
            countdownUnits2.leadingAnchor.constraint(equalTo: guide12.trailingAnchor),
            
            guide23.leadingAnchor.constraint(equalToSystemSpacingAfter: countdown2.trailingAnchor, multiplier: 1),
            guide23.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: countdownUnits2.trailingAnchor, multiplier: 1),
            guide23.widthAnchor.constraint(equalToConstant: space),
            
            countdown3.firstBaselineAnchor.constraint(equalTo: countdown1.firstBaselineAnchor),
            countdown3.leadingAnchor.constraint(equalTo: guide23.trailingAnchor),
            countdownUnits3.firstBaselineAnchor.constraint(equalTo: countdownUnits1.firstBaselineAnchor),
            countdownUnits3.leadingAnchor.constraint(equalTo: guide23.trailingAnchor),
            
            sa.bottomAnchor.constraint(equalTo: countdownUnits1.lastBaselineAnchor),
            sa.trailingAnchor.constraint(equalToSystemSpacingAfter: countdownUnits3.trailingAnchor, multiplier: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

