//
//  GlanceCellMission.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

// MARK: - Object

class GlanceMissionTVCellOld: UITableViewCell {
        
    static let identifier = "GlanceMissionTVCell"
    
    // Views
    private lazy var titleLabel = UILabel()
    private lazy var countdownLabel = UILabel()
    private lazy var myImageView = UIImageView()
    private var indicatorView = UIView()
    private var indicatorLayer: Indicator!
    
    // Geometry
    private var imageHeightConstraint = NSLayoutConstraint()
    
    // MARK: init - deinit
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCountdown(countdownLabel)
        setupTitle(titleLabel)
        setupImageView(myImageView)
        setupIndicator(indicatorView)
        setupSelf()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        countdownLabel.attributedText = nil
        myImageView.image = nil
    }
    
    // MARK: setup views and constraints
    
    private func setupCountdown(_ label: UILabel) {
        // Autolayout
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
    }
    
    private func setupTitle(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Visual
        label.font = UIFont.parentLabelFont
        label.textColor = UIColor.myAccent
        label.textAlignment = .left
        label.numberOfLines = 3
    }
    
    private func setupIndicator(_ view: UIView) {
        contentView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Layer
        indicatorLayer = Indicator(view.bounds)
        view.layer.addSublayer(indicatorLayer)
        view.layer.masksToBounds = true
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
        contentView.backgroundColor = UIColor.myPink
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        contentView
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        imageHeightConstraint = myImageView.heightAnchor.constraint(equalToConstant: 50)

        let constraints = [
            countdownLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            countdownLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            countdownLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            titleLabel.firstBaselineAnchor.constraint(equalTo: countdownLabel.firstBaselineAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            imageHeightConstraint,
            myImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            myImageView.topAnchor.constraint(equalToSystemSpacingBelow: countdownLabel.lastBaselineAnchor, multiplier: 2),
            
            indicatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            indicatorView.topAnchor.constraint(equalToSystemSpacingBelow: countdownLabel.lastBaselineAnchor, multiplier: 1),
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: myImageView.bottomAnchor, multiplier: 1)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: configure
    
    func configure(timePoint: GlanceModel) {
        titleLabel.text = timePoint.title
        myImageView.image = timePoint.image
        imageHeightConstraint.constant = timePoint.image != nil ? 50 : 0
        configureCountdownLabel(timePoint.date)
        configureIndicator(
            parentPosition: timePoint.positionOfParent,
            numberOfPhases: timePoint.numberOfPhases
        )
    }
    
    private func configureCountdownLabel(_ date: Date) {
       // countdownLabel.attributedText = getAttributedDate(fromNowTo: date)
    }
    
    private func configureIndicator(parentPosition: Int?, numberOfPhases: Int?) {
        let mission = parentPosition ?? 0
        let phases = numberOfPhases ?? 0
        indicatorLayer.configureInitialState(numberOfMarks:  phases, indexOfLongMark: mission)
    }
    
    func insertIndicatorMark() {
        indicatorLayer.insertMark()
    }
    
    func removeIndicatorMark(at index: Int) {
        indicatorLayer.removeMark(at: index)
    }
    
    func minimizeIndicator() {
        indicatorLayer.minimizeIndicator()
    }
    
    func maximizeIndicator() {
        indicatorLayer.maximizeIndicator()
    }
    
}
