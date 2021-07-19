//
//  CellInfoX.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit

//MARK: - Object

class DateIntervalCell: UICollectionViewCell, DateRepresentable {
    
    private struct Sizes {
        
        static let spacing: CGFloat = 24.0
        static let corner: CGFloat = 10.0
        
    }
    
    // MARK: properties
    private let stack = UIStackView()
    private let field1 = InfoView()
    private let field2 = InfoView()
    
    var date: Date = Date()
    var interval: DateInterval = DateInterval()
    
    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
        configure(Date())
    }

    // MARK: date representable protocol conformance
    
    func setModeTo(_ mode: ReversableDateMode) {
        switch mode {
        case .absolute:
            field2.isHidden = true
        case .relative:
            field2.isHidden = false
        }
    }

    func configure(_ date: Date) {
        let str = "14:00, 11, may, 2021".uppercased()
        let stringWithSeparators = insertSeparators(str)
        let info = finishString(stringWithSeparators)
        
        field1.configure(
            imageSystemName: "asterisk.circle.fill",
            title: "Anchor time point",
            info: info
        )
        
        field2.configure(
            imageSystemName: "flag.fill",
            title: "Result",
            info: info
        )

    }
    
    func configure(_ dateInterval: DateInterval) {
    }
    
}

// MARK: - Setup Views

private extension DateIntervalCell {
    
    private func setupViews() {
        setupSelf()
        setupStack(stack)
        setupConstraints()
    }
    
    func setupSelf() {
        contentView.backgroundColor = UIColor.mg1
        contentView.layer.cornerRadius = Sizes.corner
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(stack)
    }
    
    func setupStack(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Sizes.spacing
        
        stack.addArrangedSubview(field1)
        stack.addArrangedSubview(field2)
        field2.isHidden = true
    }
    
    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        let mg = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: mg.topAnchor),
            stack.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: mg.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: mg.bottomAnchor),
        ])
    }
    
}
