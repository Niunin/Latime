//
//  GlanceCellParent2.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class GlanceMissionTVCell: UITableViewCell {
    
    private struct Sizes {
        
        static let corner: CGFloat = 10.0
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
        
    }
    
    static let reuseIdentifier = "GlanceParentCell"
    
    // MARK: properties
    
    /// Views
    private lazy var titleLabel = UILabel()
    private lazy var customImageView = UIImageView()
    private lazy var countdownView = GlanceCountdownView()
    private lazy var indicatorView = Indicator()
    
    /// Constraints
    private var imageWidthConstraint = NSLayoutConstraint()
    private var imageHeightConstraint =  NSLayoutConstraint()
    
    // MARK: init - deinit
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
    }
    
    // MARK: configure
    
    func configure(timePoint: GlanceModel) {
        titleLabel.text = timePoint.title
        customImageView.image = timePoint.image
        //        imageWidthConstraint.constant = timePoint.image != nil ? 40 : 0
        countdownView.configure(timePoint.date)
        
        
        // FIXME: sdf-f-------
        indicatorView.removeFromSuperview()
        indicatorView = Indicator(numberOfShortMarks: timePoint.numberOfPhases ?? 0,
                                  indexOfLongMark: timePoint.positionOfParent ?? 0)
        setupViews()
        // --------
    }
    
    func insertIndicatorMark() {
        indicatorView.insertMark()
    }
    
    func removeIndicatorMark(at index: Int) {
        indicatorView.removeMark(at: index)
    }
    
    func minimizeIndicator() {
        indicatorView.minimize()
    }
    
    func maximizeIndicator() {
        indicatorView.maximize()
    }
    
}

// MARK: - Setup Views

private extension GlanceMissionTVCell {
    
    func setupViews() {
        setupSelf()
        setupTitle(titleLabel)
        setupImageView(customImageView)
        setupConstraints()
    }
    
    func setupSelf() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        contentView.addSubview(countdownView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "New point in time"
        label.font = UIFont.F2
        label.numberOfLines = 1
    }
    
    func setupImageView(_ imageView: UIImageView) {
        imageView.backgroundColor = .systemPink
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        countdownView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(0), for: .vertical)
        
        let mg = contentView.layoutMarginsGuide
        
        imageWidthConstraint = customImageView.widthAnchor.constraint(equalToConstant: 70)
        imageHeightConstraint = customImageView.heightAnchor.constraint(equalToConstant: 80)
        
        let constraints = [
            
            countdownView.topAnchor.constraint(equalTo: mg.topAnchor, constant: 8),
            countdownView.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            countdownView.widthAnchor.constraint(lessThanOrEqualTo: mg.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: countdownView.lastBaselineAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: countdownView.leadingAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: mg.widthAnchor),
            
            imageWidthConstraint,
            imageHeightConstraint,
            customImageView.trailingAnchor.constraint(equalTo: mg.trailingAnchor),
            customImageView.topAnchor.constraint(equalTo: countdownView.topAnchor),
            
            indicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            indicatorView.leadingAnchor.constraint(equalTo: countdownView.leadingAnchor),
            indicatorView.widthAnchor.constraint(equalTo: mg.widthAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 6),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        mg.bottomAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 8).isActive = true
        
        updateConstraints()
        invalidateIntrinsicContentSize()
    }
    
}

