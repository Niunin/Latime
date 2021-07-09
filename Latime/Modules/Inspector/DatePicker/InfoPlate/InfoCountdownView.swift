import UIKit

//MARK: - Object

public class InfoCountdownView: UIView {
    
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
    private var picTitleInfoView = InfoView()
    
    public override func didMoveToSuperview() {
        setupViews()
        configure(Date())
    }
    
    public func configure(_ date: Date) {
        //let result = getDateDescription(from: Date(), to: date)
        let str = "11 days, 5 hrs, 13 min"
        let stringWithSeparators = insertSeparators(str)
        let info = finishString(stringWithSeparators)
      
        var title = "remains"  // TODO: remains : Passed. Localize
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont.fontSmall)
        let image = UIImage(systemName: "timer", withConfiguration: configuration)!
        
        picTitleInfoView.configure(image: image, title: title, info: info)
        
    }
}

// MARK: - Setup Views

private extension InfoCountdownView {
    
    private func setupViews() {
        setupSelf()
        setupConstraints()
    }
    
    func setupSelf() {
        backgroundColor = UIColor.mg1
        layer.cornerRadius = Sizes.corner
        clipsToBounds = true
        
        addSubview(picTitleInfoView)
    }
    
    func setupConstraints() {
        picTitleInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = self.layoutMarginsGuide
        mg.trailingAnchor.constraint(greaterThanOrEqualTo: picTitleInfoView.trailingAnchor).isActive = true
        mg.bottomAnchor.constraint(greaterThanOrEqualTo: picTitleInfoView.bottomAnchor).isActive = true
        
        let constraints = [
            picTitleInfoView.topAnchor.constraint(equalTo: mg.topAnchor),
            picTitleInfoView.leadingAnchor.constraint(equalTo: mg.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}

extension InfoCountdownView {
    
    func insertSeparators(_ string: String) -> String{
        let array = string.components(separatedBy: ", ")
        let newString: String = array.joined(separator: " • ")
        return newString
    }
    
    func finishString(_ string: String) -> NSAttributedString {
        /// attributed string
        let attributedString = NSMutableAttributedString(string: string)
        
        /// indices
        let firstWordEndIndex = string.firstIndex(of: " ") ?? string.startIndex
        let firstWord = string[..<firstWordEndIndex]
        print(firstWord)
        
        /// ranges
        let fullRange = NSRange(location: 0, length: string.count)
        let firstWordRange = NSRange(location: 0, length: firstWord.count)
        
        /// style
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        
        /// font
        let font = UIFont.fontNormal
        let firstWordFont = UIFont.fontGiant
        attributedString.addAttribute(.font, value: font, range: fullRange)
        attributedString.addAttribute(.font, value: firstWordFont, range: firstWordRange)

        /// color
        let color = UIColor.mg2
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
        
    }

}


