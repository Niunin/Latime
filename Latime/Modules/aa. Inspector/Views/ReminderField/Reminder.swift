//
//  File.swift
//  Latime
//
//  Created by Andrei Niunin on 09.07.2021.
//

import UIKit

//MARK: - Object

public class ReminderView: UIStackView {
    
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
    
    private var title = UILabel()
    private var button = UIButton()
    private var stackHorizontal = UIStackView()
    
    public override func didMoveToSuperview() {
        setupViews()
    }
    
    public func configure(state: Bool) {
        
    }
}

// MARK: - Setup Views

private extension ReminderView {
    
    private func setupViews() {
        setupSelf()
        setupTitle(title)
        setupButton(button)
        setupConstraints()
    }
    
    func setupSelf() {
        axis = .horizontal
        alignment = .center
        spacing = Sizes.spacing
        
        addArrangedSubview(title)
        addArrangedSubview(button)
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "Reminder"
        label.font = UIFont.F12
        label.textColor = UIColor.mb
    }
    
    func setupButton(_ button: UIButton) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.F3)
        let image = UIImage(systemName: "bell.fill", withConfiguration: configuration)!
        
        button
        button.setImage(image, for: .normal)
        button.setTitle("Alarm", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.mg1
        button.tintColor = UIColor.mg2
        button.setTitleColor(UIColor.mg2, for: .normal)
        button.addTarget(self, action: #selector(actionX), for: .touchUpInside)
    }
    
    @IBAction func actionX() {
        if button.title(for: .normal) == "Alarm" {
            button.setTitle("Off", for: .normal)
        } else {
            button.setTitle("Alarm", for: .normal)
        }
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        let constraints = [
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            //heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
