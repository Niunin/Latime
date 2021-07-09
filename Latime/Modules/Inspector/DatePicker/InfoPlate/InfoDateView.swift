import UIKit

//MARK: - Object

public class DateIntervalView: UIView {
    
    // MARK: sizes data
    
    private struct Sizes {
    
        static let spacing: CGFloat = 4.0
        static let corner: CGFloat = 10.0
        static let topOffset: CGFloat = 20
        static let btmOffset: CGFloat = 15
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = 15
    
    }
    
    // MARK: properties
    private var initialInfoView = InfoView()
    private var resultInfoView = InfoView()
    
    public override func didMoveToSuperview() {
        setupViews()
        configure(Date())
    }
    
    public func configure(_ date: Date) {
        //let result = getDateDescription(from: Date(), to: date)
        let str = "14:00, 11, may, 2021".uppercased()
        
        let stringWithSeparators = insertSeparators(str)
        let info = finishString(stringWithSeparators)
      
        let title = "Anchor time point"  // TODO: remains : Passed. Localize
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.fontSmall)
        let image = UIImage(systemName: "asterisk.circle.fill", withConfiguration: configuration)!
        
        initialInfoView.configure(image: image, title: title, info: info)
        
        resultInfoView.configure(image: image, title: title, info: info)
        
    }
}

// MARK: - Setup Views

private extension DateIntervalView {
    
    private func setupViews() {
        setupSelf()
        setupConstraints()
    }
    
    func setupSelf() {
        backgroundColor = UIColor.mg1
        layer.cornerRadius = Sizes.corner
        clipsToBounds = true
        
        addSubview(initialInfoView)
        addSubview(resultInfoView)
    }
    
    func setupConstraints() {
        initialInfoView.translatesAutoresizingMaskIntoConstraints = false
        resultInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = self.layoutMarginsGuide
        mg.trailingAnchor.constraint(greaterThanOrEqualTo: initialInfoView.trailingAnchor).isActive = true
        mg.bottomAnchor.constraint(greaterThanOrEqualTo: resultInfoView.bottomAnchor).isActive = true
        
        let constraints = [
            initialInfoView.topAnchor.constraint(equalTo: mg.topAnchor),
            initialInfoView.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            
            resultInfoView.topAnchor.constraint(equalToSystemSpacingBelow: initialInfoView.bottomAnchor, multiplier: 3),
            resultInfoView.leadingAnchor.constraint(equalTo: initialInfoView.leadingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        
    }

}

extension DateIntervalView {
    
    func insertSeparators(_ string: String) -> String{
        let array = string.components(separatedBy: ", ")
        let newString: String = array.joined(separator: " • ")
        return newString
    }
    
    func finishString(_ string: String) -> NSAttributedString {
        /// attributed string
        let attributedString = NSMutableAttributedString(string: string)
        
        /// ranges
        let fullRange = NSRange(location: 0, length: string.count)
        
        /// style
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        
        /// font
        let font = UIFont.fontButtonText
        attributedString.addAttribute(.font, value: font, range: fullRange)

        /// color
        let color = UIColor.mg2
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
        
    }
    
    
}


