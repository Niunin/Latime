//
//  pointView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

public class TimePointView: UIView {
    
    // MARK: sizes data
    
    private struct Sizes {
    
        static let corner: CGFloat = 10.0
        
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
    
    }
    
    // MARK: properties
    
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let dayLabel = UILabel()
    private let monthLabel = UILabel()
    private let yearLabel = UILabel()
    private let timeLabel = UILabel()
    
    public override func didMoveToSuperview() {
        setupViews()
    }
    
}

private extension TimePointView {
    
    func setupViews() {
        setupSelf()
        setupContentView(contentView)
        setupDayLabel(dayLabel)
        setupMonthLabel(monthLabel)
        setupYearLabel(yearLabel)
        setupTimeLabel(timeLabel)
        
        setupConstraints()
    }
    
    
    func setupSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray6
        self.clipsToBounds = true
        self.layer.cornerRadius = Sizes.corner
        self.layer.masksToBounds = true
    }
    
    func setupContentView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupDayLabel(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .systemGray3
        label.text = "26"
    }
    
    func setupMonthLabel(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .systemGray3
        label.text = "JUL"
    }
    
    func setupYearLabel(_ label: UILabel) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .systemGray3
        label.text = "2021"
    }
    
    func setupTimeLabel(_ label: UILabel) {
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray3
        label.text = "at 14:06"
    }

    
    func setupConstraints() {
        let sa = self.safeAreaLayoutGuide
        let constraints = [
            contentView.centerXAnchor.constraint(equalTo: sa.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: sa.topAnchor, constant: 10),
            
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            monthLabel.bottomAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 10),
            
            yearLabel.topAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 10),
            
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: yearLabel.lastBaselineAnchor, constant: 15),
            
            contentView.trailingAnchor.constraint(equalTo: monthLabel.trailingAnchor),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: yearLabel.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: timeLabel.lastBaselineAnchor),
            
            sa.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
