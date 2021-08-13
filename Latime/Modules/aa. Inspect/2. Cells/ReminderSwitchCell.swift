//
//  CellText.swift
//  Latime
//
//  Created by Andrei Niunin on 13.07.2021.
//

import UIKit

class ReminderSwitchCell: UICollectionViewCell {
    
    private struct Sizes {
        
        static let spacing: CGFloat = 8.0
        static let corner: CGFloat = 10.0
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
        
    }
    
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    // MARK: properties
    
    let stack = UIStackView()

    private var title = UILabel()
    private var button = UIButton()
    private var stackHorizontal = UIStackView()
    
    // MARK: init - deinit
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: configure
    
    public func configure(state: Bool) {
        
    }
    
    func configure() {
        backgroundColor = .green
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        let inset = CGFloat(30)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
}

// MARK: - Setup Views

private extension ReminderSwitchCell {
    
    private func setupViews() {
        setupSelf()
        setupTitle(title)
        setupButton(button)
        setupConstraints()
    }
    
    func setupSelf() {
        contentView.addSubview(stack)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Sizes.spacing
        contentView.backgroundColor = UIColor.white
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(button)
    }
    
    func setupTitle(_ label: UILabel) {
        label.text = "Reminder"
        label.font = UIFont.F12
        label.textColor = UIColor.mb
    }
    
    func setupButton(_ button: UIButton) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.F3)
        let image = UIImage(systemName: "bell.fill", withConfiguration: configuration)!
        
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
        stack.translatesAutoresizingMaskIntoConstraints = false

        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        let inset = CGFloat(0)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
//            title.topAnchor.constraint(equalTo: self.topAnchor),
//            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            //heightAnchor.constraint(equalToConstant: 200)
        ])
    }

}
