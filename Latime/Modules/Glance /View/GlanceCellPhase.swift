//
//  GlanceCellPhase.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

// MARK: - Object

class GlancePhaseTVCell: UITableViewCell {
    
    // MARK: properties
    
    static let identifier = "GlancePhaseTVCell"
    // Views
    private lazy var stack = UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var countdownLabel = UILabel()
    private lazy var myImageView = UIImageView()
    
    // MARK: init - deinit
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack(stack)
        setupTitleLabel(titleLabel)
        setupCountdownLabel(countdownLabel)
        setupImageView(myImageView)
        setupSelf()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: setup views and constraints
    
    private func setupStack(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        stack.axis = .vertical
        stack.addArrangedSubview(countdownLabel)
        stack.addArrangedSubview(titleLabel)
        stack.setCustomSpacing(8, after: countdownLabel)
    }
    
    private func setupCountdownLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.myAccent
    }
    
    private func setupTitleLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.phaseLabelFont
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
    }
    
    private func setupImageView(_ imageView: UIImageView) {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    private func setupSelf() {
        contentView.backgroundColor = UIColor.myViewBackground
        selectionStyle = .none
        
    }
    
    private func setupConstraints() {
        let constraints = [
            countdownLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            myImageView.topAnchor.constraint(equalTo: stack.topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            myImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: configure
    
    func configure(timePoint: GlanceModel) {
        titleLabel.text = timePoint.title
        countdownLabel.text = DateModel.fullDateDescription(from: Date(), to: timePoint.date)
        myImageView.image = timePoint.image
    }
    
}

