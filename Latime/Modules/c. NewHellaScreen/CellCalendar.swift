import UIKit

class DateCell: UICollectionViewCell {
    
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    let inset = CGFloat(10)
    lazy var bottomConstrant = picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    
    func setAsMain(_ b: Bool) {
        if b {
            bottomConstrant.isActive = true
        } else {
            bottomConstrant.isActive = false
        }
    }
    
}

// MARK: - extensino

extension DateCell {
    func configure() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            picker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
        ])
        bottomConstrant.isActive = true
    }
}
