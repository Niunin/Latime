//
//  TimelineCellToday.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation

import UIKit

class TimelineCellToday: UICollectionViewCell {
    
    static let reuseIdentifier = "TimelineCellToday"
    
    // MARK: properties
    
    private let title = UILabel()
    
    
    
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
        contentView.addSubview(title)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .mg1
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "Now you are here"
        label.font = .F4
        label.textColor = .mg2
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = contentView.layoutMarginsGuide
        mg.bottomAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        mg.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
        
        let constraints = [
            title.topAnchor.constraint(equalTo: mg.topAnchor),
            title.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
//            title.trailingAnchor.constraint(equalTo: mg.trailingAnchor),
            title.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
