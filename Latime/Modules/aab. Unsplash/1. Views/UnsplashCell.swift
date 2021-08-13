//
//  CellUnsplash.swift
//  iX-33
//
//  Created by Andrea Nunti on 01.04.2021.
//

import UIKit

// MARK: - Object

class UnsplashCell: UICollectionViewCell {
    
    // MARK: properties
    static let identifier = "UnsplashCell"
    
    // Views
    let imageView = UIImageView()
    let titleLabel = UITextView()
    
    // Model
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    var title: NSAttributedString? {
        didSet { titleLabel.attributedText = title }
    }
    
    // MARK: init - deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        image = nil
        title = nil
    }
    
    // MARK: setup Views
    
    func setupViews() {
        setupTitleLabel(titleLabel)
        setupImageView(imageView)
        setupConstraints()
    }
    
    func setupTitleLabel(_ textView: UITextView) {
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.delegate = self
    }
    
    func setupImageView(_ imageView: UIImageView) {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func setupConstraints() {
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    // MARK: conigure
    
    func configure(for cell: UnsplashCell, choice: ImageSource, image: UIImage?) {
        let title = choice.username
        let link = choice.link
        
        let hotlink = NSMutableAttributedString(string: title)
        hotlink.addAttribute(.link, value: link, range: NSRange(location: 0, length: title.count))
        
        cell.title = hotlink
        cell.image = image
    }
    
}

// MARK: - extension
extension UnsplashCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
}
