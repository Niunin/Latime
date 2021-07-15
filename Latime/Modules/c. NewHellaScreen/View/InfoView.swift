//
//  CellInfo.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit

//MARK: - Object

class CellInfoView: UIView {

    private struct Sizes {

        static let spacing: CGFloat = 8.0
        static let corner: CGFloat = 10.0

    }
    
    // MARK: properties
    
    private let stackVertical = UIStackView()
    private let stackHorizontal = UIStackView()
    private let icon = UIImageView()
    private let title = UILabel()
    private let info = UILabel()
    
    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: methods
    
    func configure(imageSystemName: String, title: String, info: NSAttributedString) {
        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.F5)
        let image = UIImage(systemName: imageSystemName, withConfiguration: imageConfiguration)!
        
        self.icon.image = image
        self.title.text = title.uppercased()
        self.info.attributedText = info
    }
    
}

// MARK: - Setup Views

private extension CellInfoView {
    
    private func setupViews() {
        setupSelf()
        
        setupImage(icon)
        setupTitle(title)
        setupStackHorizontal(stackHorizontal)
        setupStackVertical(stackVertical)
        
        setupConstraints()
    }
    
    func setupSelf() {
        addSubview(stackVertical)
    }
    
    func setupImage(_ imageView: UIImageView) {
        imageView.tintColor = UIColor.mg2
    }
    
    func setupTitle(_ label: UILabel) {
        label.font = UIFont.F5
        label.textColor = UIColor.mg2
    }
    
    func setupStackHorizontal(_ stack: UIStackView) {
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Sizes.spacing
        
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(title)
    }
    
    func setupStackVertical(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Sizes.spacing
        
        stack.addArrangedSubview(stackHorizontal)
        stack.addArrangedSubview(info)
    }
    
    func setupConstraints() {
        stackVertical.translatesAutoresizingMaskIntoConstraints = false
        
        self.trailingAnchor.constraint(equalTo: stackVertical.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: stackVertical.bottomAnchor).isActive = true
        
        let constraints = [
            stackVertical.topAnchor.constraint(equalTo: self.topAnchor),
            stackVertical.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
