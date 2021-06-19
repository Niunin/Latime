//
//  GlanceCellParent2.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

public class GlanceMissionTVCell: UITableViewCell {
        
    static let identifier = "GlanceMissionTVCell"
    
    // Views
    private lazy var titleLabel = UILabel()
    private lazy var customImageView = UIImageView()
    private lazy var countdownView = CountdownView()
    private lazy var indicatorView = IndicatorView()
    
    private var imageWidthConstraint = NSLayoutConstraint()
    private var imageHeightConstraint =  NSLayoutConstraint()
    
    public override func didMoveToSuperview() {
        setupViews()
    }
    
    func configure(timePoint: GlanceModel) {
        titleLabel.text = timePoint.title
        customImageView.image = timePoint.image
        imageWidthConstraint.constant = timePoint.image != nil ? 40 : 0
        countdownView.configure(timePoint.date)
        
        indicatorView.configureInitialState(numberOfMarks: timePoint.numberOfPhases ?? 0,
                                            indexOfLongMark: timePoint.positionOfParent ?? 0,
                                            aimedMark: 0)
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
    
}

// MARK: Setup Views and Constraints

private extension GlanceMissionTVCell {
    
    func setupViews() {
        setupTitle(titleLabel)
        setupCountdown()
        setupIndicator()
        setupImageView(customImageView)
        
        setupSelf()
        setupConstraints()
    }
    
    func setupTitle(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New point in time"
        label.setContentHuggingPriority(UILayoutPriority(000), for: .vertical)
    }
    
    func setupCountdown() {
        contentView.addSubview(countdownView)
        countdownView.translatesAutoresizingMaskIntoConstraints = false
        setNeedsLayout()
    }
    
    func setupIndicator() {
        contentView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupImageView(_ imageView: UIImageView) {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Visual
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    func setupSelf() {
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 5
        selectionStyle = .none
    }
    
    func setupConstraints() {
        let lmg = contentView.layoutMarginsGuide
        
        imageWidthConstraint = customImageView.widthAnchor.constraint(equalToConstant: 80)
        imageHeightConstraint = customImageView.heightAnchor.constraint(equalToConstant: 60)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: lmg.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: customImageView.leadingAnchor, constant: 8),
            
            countdownView.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 10),
            countdownView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            imageWidthConstraint,
            imageHeightConstraint,
            customImageView.trailingAnchor.constraint(equalTo: lmg.trailingAnchor),
            customImageView.bottomAnchor.constraint(equalTo: countdownView.firstBaselineAnchor),
            
            indicatorView.leadingAnchor.constraint(equalTo: countdownView.trailingAnchor, constant: 5 ),
            indicatorView.trailingAnchor.constraint(equalTo: lmg.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: countdownView.lastBaselineAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 6),
            
            lmg.bottomAnchor.constraint(equalTo: countdownView.lastBaselineAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
