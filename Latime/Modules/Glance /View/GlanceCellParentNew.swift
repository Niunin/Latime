//
//  GlanceNewCell.swift
//  Latime
//
//  Created by Andrei Niunin on 30.05.2021.
//

import UIKit

// MARK: - DataStructure

struct GlanceCountDown {
    
    let countdownMain: NSAttributedString
    let countdown2: NSAttributedString?
    let countdown3: NSAttributedString?
    
}

// MARK: - Object

class GlanceMissionTVCell: UITableViewCell {
        
    static let identifier = "GlanceMissionTVCell2"
    
    // Views
    private lazy var titleLabel = UILabel()
    
    private lazy var countdownsStack = UIStackView()
    private lazy var countdownMain = UILabel()
    private lazy var countdown2 = UILabel()
    private lazy var countdown3 = UILabel()
    
    private lazy var CustomImageView = UIImageView()
    
    private lazy var indicatorView = IndicatorView()
    
    private lazy var myImageView = UIImageView()
    
    // Geometry
    private var imageWidthConstraint = NSLayoutConstraint()
    
    // MARK: init - deinit
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("-- Layout")
        print(" Ind bounds: \(indicatorView.bounds), clock view bounds: \(countdownsStack.bounds)")
    }
    
    // MARK: setup views and constraints

    private func setupViews() {
        setupTitle(titleLabel)
        setupCountdown(countdownMain)
        setupCountdown(countdown2)
        setupCountdown(countdown3)
        setupCountdownsStack(countdownsStack)
        setupIndicator()
        setupSelf()
        
        setupConstraints()
//        countdownsStack.backgroundColor = UIColor.systemPink
//        indicatorView.backgroundColor = UIColor.red
    }
    
    private func setupTitle(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.parentLabelFont
        label.textColor = UIColor.myAccent
        label.textAlignment = .left
        label.numberOfLines = 3
    }
    
    private func setupCountdown(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
    }
    
    private func setupCountdownsStack(_ stack: UIStackView) {
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .bottom
        stack.isBaselineRelativeArrangement = true
        stack.axis = .horizontal
        stack.spacing = 15
        
        stack.addArrangedSubview(countdownMain)
        stack.addArrangedSubview(countdown2)
        stack.addArrangedSubview(countdown3)
        
        countdownMain.setContentHuggingPriority(UILayoutPriority.init(1000), for: .horizontal)
        countdown2.setContentHuggingPriority(UILayoutPriority.init(1000), for: .horizontal)
        countdown3.setContentHuggingPriority(UILayoutPriority.init(1000), for: .horizontal)
        
        countdownMain.setContentCompressionResistancePriority(UILayoutPriority.init(1000), for: .horizontal)
        countdown2.setContentCompressionResistancePriority(UILayoutPriority.init(1000), for: .horizontal)
        countdown3.setContentCompressionResistancePriority(UILayoutPriority.init(1000), for: .horizontal)
        
//        countdownMain.backgroundColor = .red
//        countdown2.backgroundColor = .blue
//        countdown3.backgroundColor = .green
    }

    private func setupIndicator() {
        contentView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupImageView(_ imageView: UIImageView) {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Visual
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    private func setupSelf() {
        contentView.backgroundColor = UIColor.myViewBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        imageWidthConstraint = myImageView.heightAnchor.constraint(equalToConstant: 0)

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: 1),
            
            countdownsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            countdownsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            countdownsStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.widthAnchor),
        
            indicatorView.leadingAnchor.constraint(equalTo: countdownsStack.trailingAnchor, constant: 5 ),
            indicatorView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: countdownMain.lastBaselineAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 6),
            
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: countdownsStack.bottomAnchor, multiplier: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: configure
    
    func configure(timePoint: GlanceModel) {
        titleLabel.text = timePoint.title
        myImageView.image = timePoint.image
        
        imageWidthConstraint.constant = timePoint.image != nil ? 40 : 0
        configureCountdownLabel(timePoint.date)
        
        indicatorView.configureInitialState(numberOfMarks: timePoint.numberOfPhases ?? 0,
                                            indexOfLongMark: timePoint.positionOfParent ?? 0,
                                            aimedMark: 0)
    }

    private func configureCountdownLabel(_ date: Date) {
        
        let result = getDateDescription(from: Date(), to: date)
        countdownMain.attributedText = result.countdownMain
        countdown2.attributedText = result.countdown2
        countdown3.attributedText = result.countdown3
    }
    
    func insertIndicatorMark() {
        indicatorView.insertMark()
    }
    
    func removeIndicatorMark(at index: Int) {
        indicatorView.removeMark(at: index)
    }
    
    func minimizeIndicator() {
        indicatorView.minimizeIndicator()
    }
    
    func maximizeIndicator() {
        indicatorView.maximizeIndicator()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "UIView.bounds" {
            indicatorView.frame = indicatorView.bounds
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
}

func getDateDescription(from start: Date, to end: Date) -> GlanceCountDown {
    let str = DateModel.fullDateDescription(from: start, to: end)
    let array = str.components(separatedBy: ", ")
    
    let largeFont = UIFont.conuntdownNumber
    let smallFont = UIFont.conuntdown2Number
    
    switch array.count {
    case 1:
        return GlanceCountDown(
            countdownMain: getAttributedDate(description: array.first!, timeFont: largeFont),
            countdown2: nil,
            countdown3: nil)
    case 2:
        return GlanceCountDown(
            countdownMain: getAttributedDate(description: array[0], timeFont: largeFont),
            countdown2: getAttributedDate(description: array[1], timeFont: largeFont),
            countdown3: nil
        )
    default:
        return GlanceCountDown(
            countdownMain: getAttributedDate(description: array[0], timeFont: largeFont),
            countdown2: getAttributedDate(description: array[1], timeFont: smallFont),
            countdown3: getAttributedDate(description: array[2], timeFont: smallFont)
        )
    }
}




// TODO: Refactor this
func getAttributedDate(description: String, timeFont: UIFont) -> NSAttributedString {
    let descriptionString = String(description.map{$0 == " " ? "\n" : $0} )

    // Substrings
    let index: String.Index = descriptionString.firstIndex(of: "\n") ?? descriptionString.endIndex
    let countdownSubstring = descriptionString[..<index]
    let suffixSubstring = descriptionString[index..<descriptionString.endIndex]
    
    // NSRanges
    let fullNSRange = NSRange(location: 0, length: descriptionString.count)
    
    let countdownRange = descriptionString.range(of: countdownSubstring)!
    let countdownNSRange = NSRange(countdownRange, in: descriptionString)
    
    var suffixNSRange = NSRange(location: 0, length: 0)
    if suffixSubstring.count > 0 {
        let suffixRange = descriptionString.range(of: suffixSubstring)!
        suffixNSRange = NSRange(suffixRange, in: descriptionString)
    }

    // Visual
    let unitsFont = UIFont.countdownSuffix
//    let unitsColor = UIColor.systemGray
    
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 0
    style.lineBreakMode = .byTruncatingTail
    style.alignment = .left
    
    // Attributed string
    let attributedString = NSMutableAttributedString(string: descriptionString)
    attributedString.addAttribute(.paragraphStyle, value: style, range: fullNSRange)
    attributedString.addAttribute(.font, value: timeFont, range: countdownNSRange)
    attributedString.addAttribute(.font, value: unitsFont, range: suffixNSRange)
//    attributedString.addAttribute(.foregroundColor, value: unitsColor, range: suffixNSRange)
    
    return attributedString
}
