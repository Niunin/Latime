//
//  CellInfoX.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit

//MARK: - Object

class DisplayResultCell: UICollectionViewCell, DateRepresentable {
    
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: date representable protocol conformance
    
    func configure(initialDate: Date) {
        let format = "HH:mm '•' dd '•' MMM '•' yyyy"

        let df = DateFormatter()
        df.dateFormat = format
        let description1 = df.string(from: initialDate)
        let str1 = description1.uppercased()
        let info1 = finishString(str1)
        
        field1.configure(info: info1)
        field1.configure(title: "Relative to", imageSystemName: "asterisk.circle.fill")
    }
    
    func configure(resultDate: Date) {
        let format = "HH:mm '•' dd '•' MMM '•' yyyy"

        let df = DateFormatter()
        df.dateFormat = format
        
        let description2 = df.string(from: resultDate)
        let str2 = description2.uppercased()
        let info2 = finishString(str2)
        
        field2.configure(info: info2)
        field2.configure(title: "Result", imageSystemName: "flag.fill")
        field2.isHidden = false
    }
    
    func configure(timeInterval: TimeInterval) {
        let date1: Date = Date()
        let date2: Date = Date(timeIntervalSinceNow: timeInterval)

        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.collapsesLargestUnit = false
        componentsFormatter.allowedUnits = [.day, .hour, .minute]
        componentsFormatter.unitsStyle = .short

        componentsFormatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing, .dropTrailing ]
        let componentsDescription = componentsFormatter.string(from: date1, to: date2)!
        let str = insertSeparators(componentsDescription)
        let info = finishString(str)
        
        field1.configure(info: info)
        field1.configure(title: "Time remains", imageSystemName: "timer")
        field2.isHidden = true

    }
  
}

// MARK: - Setup Views

private extension DisplayResultCell {
    
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
