//
//  TimelineCellToday.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit

// MARK: - Object

class TimelineCellToday: UICollectionReusableView {
    
    struct Sizes {
        static let inset: CGFloat = 20
    }
    
    // MARK: properties
    
    static let reuseIdentifier = "Timeline-today-title-identifier"
    
    private let title = UILabel()

    // MARK: life cycle
    override func didMoveToSuperview() {
        setupViews()
    }
    
}

// MARK: - Setup Views

extension TimelineCellToday {
    
    func setupViews() {
        setupSelf()
        setupTitle(title)
        setupConstraints()
    }
    
    func setupSelf() {
        addSubview(title)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .mg1
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "Now you are here"
        label.font = .F4
        label.textColor = .mg2
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = layoutMarginsGuide
                
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.inset),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.inset),
            title.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.inset),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.inset),
        ])
    }
    
}
