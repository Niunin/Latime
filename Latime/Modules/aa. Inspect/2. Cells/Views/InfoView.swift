//
//  InformationView.swift
//  Latime
//
//  Created by Andrei Niunin on 15.07.2021.
//

import Foundation

import UIKit


//MARK: - Object

class InfoView: UIView {
    
    // MARK: sizes data
    
    private struct Sizes {
        
        static let spacing: CGFloat = 8.0
        static let corner: CGFloat = 10.0
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
        
    }
    
    // MARK: properties
    
    private var pic = UIImageView()
    private var title = UILabel()
    private var info = UILabel()
    private var stackHorizontal = UIStackView()
    private let stackVertical = UIStackView()
    
    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: configure
    
    func configure(title: String, imageSystemName: String) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.F5)
        let image = UIImage(systemName: imageSystemName, withConfiguration: configuration)!
        
        self.pic.image = image
        self.title.text = title.uppercased()
    }
    
    func configure(info: NSAttributedString) {
        self.info.attributedText = info
    }
    
}

// MARK: - Setup Views

private extension InfoView {
    
    private func setupViews() {
        setupSelf()
        setupImage(pic)
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
        
        stack.addArrangedSubview(pic)
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
        pic.translatesAutoresizingMaskIntoConstraints = false
        stackVertical.translatesAutoresizingMaskIntoConstraints = false
        
        self.trailingAnchor.constraint(greaterThanOrEqualTo: stackVertical.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(greaterThanOrEqualTo: stackVertical.bottomAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            stackVertical.topAnchor.constraint(equalTo: self.topAnchor),
            stackVertical.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
}

