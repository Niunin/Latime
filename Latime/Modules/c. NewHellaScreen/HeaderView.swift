import UIKit

public protocol TitleSegmentedDelegate: AnyObject {
    //var currentSegment: Int? { get set }
    func currentSegment(_:Int)
}

public class TitleSegmentedView: UICollectionReusableView {
    
    static let reuseIdentifier = "segmented-control-title-identifier"
    public weak var delegate: TitleSegmentedDelegate?
    
    public let segmentedControl = UISegmentedControl()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupSegmentedControl(segmentedControl)
        setupConstraints()
        
        print("SC")
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

public extension TitleSegmentedView {
    
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
        delegate?.currentSegment(sender.selectedSegmentIndex)
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
