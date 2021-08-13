import UIKit

class InputModeSwitchHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "segmented-control-title-identifier"
    weak var delegate: TitleSegmentedDelegate?
    
    let segmentedControl = UISegmentedControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupSegmentedControl(segmentedControl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension InputModeSwitchHeader {
    
    func setupSelf() {
        addSubview(segmentedControl)
    }
    
    func setupSegmentedControl(_ segmentedControl: UISegmentedControl) {
        segmentedControl.insertSegment(withTitle: "Absolute", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Relative", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
    }
    
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        delegate?.setCurrentSegment(sender.selectedSegmentIndex)
    }
    
    func setupConstraints() {
        let inset = CGFloat(2)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            //segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
