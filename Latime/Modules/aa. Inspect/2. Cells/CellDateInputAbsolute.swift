import UIKit

// MARK: - Object

class DateCell: UICollectionViewCell {
    
    static let reuseIdentifier = "text-cell-reuse-identifier"

    // MARK: properties
    
    weak var delegate: InspectDateInputDelegate!

    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    
    let inset = CGFloat(0)
    lazy var bottomConstrant = picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    
    // MARK: init - deinit
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
      
    // MARK: configure
    
    func configure() {
        backgroundColor = .systemBackground
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
