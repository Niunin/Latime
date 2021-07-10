//
//  GlanceCellPhase.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

// MARK: - Object

class GlancePhaseTVCell: UITableViewCell {
    
    struct Sizes {
        
        static let separatorInsets = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 0)
        static let leadingOffset: CGFloat = 30
        static let widthOffset = -1 * (leadingOffset * 2)
    }
    
    static let reuseIdentifier = "GlancePhaseCell"
    
    // MARK: properties

    // Views
    private lazy var label = UILabel()
    
    // MARK: init - deinit
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure
    
    func configure(timePoint: GlanceModel) {
        let title = timePoint.title
        let time = DateModel.fullDateDescription(from: Date(), to: timePoint.date)
        label.attributedText = getDescriptionText(title, time)
    }
    
}

// MARK: - Setup Views and Constraints

private extension GlancePhaseTVCell {
    
    
    
    func setupViews() {
        setupSelf()
        setupLabel(label)
        setupConstraints()
    }
    
    func setupSelf() {
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.myViewBackground
        selectionStyle = .none
        separatorInset = Sizes.separatorInsets
        contentView.addSubview(label)
    }
    
    func setupLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
    }
    
    func setupConstraints() {
        let mg = contentView.layoutMarginsGuide
        let constraints = [
            label.topAnchor.constraint(equalTo: mg.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: mg.leadingAnchor, constant: Sizes.leadingOffset),
            label.widthAnchor.constraint(equalTo: mg.widthAnchor, multiplier: 1, constant: Sizes.widthOffset),
            //mg.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ]
        NSLayoutConstraint.activate(constraints)
        let h = mg.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        h.isActive = true
        h.priority = UILayoutPriority(999)
    }
    
}

// MARK: prepare attributed text

private extension GlancePhaseTVCell {
    
    // FIXME: Bad impleentation
    func getDescriptionText(_ title: String,_ time: String) -> NSAttributedString{
        let attributedTitle: NSAttributedString = configureTitleText(title)
        let attributedTime: NSAttributedString = configureCounterText(time)
        
        let space = NSMutableAttributedString(string: "  ")
        let result = NSMutableAttributedString()
        result.append(attributedTitle)
        result.append(space)
        result.append(attributedTime)
        return result
    }
    
    func configureTitleText(_ text: String) -> NSAttributedString {
        
        //        // Substrings
        //        let index: String.Index = descriptionString.firstIndex(of: "\n") ?? descriptionString.endIndex
        //        let countdownSubstring = descriptionString[..<index]
        //        let suffixSubstring = descriptionString[index..<descriptionString.endIndex]
        //
        //        // NSRanges
        //        let fullNSRange = NSRange(location: 0, length: descriptionString.count)
        //        let countdownRange = descriptionString.range(of: countdownSubstring)!
        //        let countdownNSRange = NSRange(countdownRange, in: descriptionString)

        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: text.count)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        
        let font = UIFont.F3
        let color = UIColor.black
        
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
    }
    
    func configureCounterText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        let fullRange = NSRange(location: 0, length: text.count)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        
        let font = UIFont.F3
        let color = UIColor.gray
        
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
    }
        
}
