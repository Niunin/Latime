//
//  GlanceCountdownView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

//MARK: - Object

class GlanceCountdownView: UIView {
    
    // MARK: properties
    
    private var countdown1 = UILabel()
    private var countdown2 = UILabel()
    private var countdown3 = UILabel()
    
    private lazy var countdownUnits1 = UILabel()
    private lazy var countdownUnits2 = UILabel()
    private lazy var countdownUnits3 = UILabel()
    
    private let stack = UIStackView()
    
    // MARK: life cycle
    
    override var lastBaselineAnchor: NSLayoutYAxisAnchor {
        get {
            countdown1.lastBaselineAnchor
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
    
    // MARK: configure
    
    func configure(_ timePoint: GlanceEntity) {
        //let str = DateModel.fullDateDescription(from: Date(), to: date)
        let str = timePoint.fullDateDescription()
        let stringWithSeparators = insertSeparators(str)
        let info = finishString(stringWithSeparators)
        countdown1.attributedText = info
    }
    
}

// MARK: - Setup Views

private extension GlanceCountdownView {
    
    func setupViews() {
        setupSelf()
        setupStackView(stack)
        setupConstraints()
    }
    
    func setupSelf() {
        self.addSubview(stack)
    }
    
    func setupStackView(_ stack: UIStackView) {
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.spacing = 4
        
        stack.addArrangedSubview(countdown1)
    }
    
    func setupConstraints() {
        self.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        heightAnchor.constraint(greaterThanOrEqualTo: stack.heightAnchor).isActive = true
    }
    
}

// MARK: - Attributed Text

private extension GlanceCountdownView {
    func insertSeparators(_ string: String) -> String{
        let array = string.components(separatedBy: ", ")
        let newString: String = array.joined(separator: " • ")
        return newString
    }
    
    func finishString(_ string: String) -> NSAttributedString {
        /// attributed string
        let attributedString = NSMutableAttributedString(string: string)
        
        /// indices
        let firstWordEndIndex = string.firstIndex(of: " ") ?? string.startIndex
        let firstWord = string[..<firstWordEndIndex]
        
        /// ranges
        let fullRange = NSRange(location: 0, length: string.count)
        let firstWordRange = NSRange(location: 0, length: firstWord.count)
        
        /// style
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        
        /// font
        let font = UIFont.F12
        let firstWordFont = UIFont.F0
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.font, value: firstWordFont, range: firstWordRange)
        
        /// color
        let color = UIColor.mb
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
    }
}
