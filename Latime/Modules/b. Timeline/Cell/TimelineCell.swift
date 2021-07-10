//
//  TimelineCellCollectionViewCell.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit

// MARK: - Object

class TimelineCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TimelineCell"
    
    // MARK: properties
    
    private let stack = UIStackView()
    private let stackVertical = UIStackView()
    private let mark = UIView()
    private let title = UILabel()
    private let date = UILabel()
    private let countdown = UILabel()
    
    override func didMoveToSuperview() {
        setupViews()
    }
}

// MARK: - Setup Views

extension TimelineCell {
    
    func setupViews() {
        setupSelf()
        setupTitle(title)
        setupDate(date)
        setupCountdown(countdown)
        setupMark(mark)
        setupStackVertical(stackVertical)
        setupStack(stack)
        
        setupConstraints()
    }
    
    func setupSelf() {
        contentView.addSubview(stack)
        backgroundColor = .white
    }
    
    func setupMark(_ view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .mg1
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "Some phase"
        label.font = .F3
    }
    
    func setupDate(_ label: UILabel) {
        label.text = "14:00 • 27 JUNE • 2021"
        label.font = .F7
        label.textColor = .mg2
    }
    
    func setupCountdown(_ label: UILabel) {
        label.font = .F3
        label.text = "4 days"
    }
    
    func setupStackVertical(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.setContentHuggingPriority(UILayoutPriority(0), for: .horizontal)
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(date)
    }
    
    func setupStack(_ stack: UIStackView) {
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fill
        stack.setContentHuggingPriority(UILayoutPriority(0), for: .horizontal)
        
        stack.addArrangedSubview(mark)
        stack.addArrangedSubview(stackVertical)
        stack.addArrangedSubview(countdown)
    }
    
    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        mark.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = contentView.layoutMarginsGuide
        mg.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        mg.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        
        let constraints = [
            stack.topAnchor.constraint(equalTo: mg.topAnchor),
            stack.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: mg.trailingAnchor),
            stack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            mark.widthAnchor.constraint(equalToConstant: 10),
            mark.heightAnchor.constraint(equalToConstant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
