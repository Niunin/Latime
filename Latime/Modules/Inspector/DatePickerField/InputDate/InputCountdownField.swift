import UIKit

public class InputDateField: UIStackView {
    // MARK: Sizes
    
    private struct Sizes {
        static let corner: CGFloat = 10.0
        static let textFieldCorner: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let textFieldInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 0)
        
        static let topAnchorOffset: CGFloat = 10.0
        static let btmAnchorOffset: CGFloat = 30.0
        static let leadingAnchorOffset: CGFloat = 0.0
        static let trailingAnchorOffset: CGFloat = 0.0
        
        static let verticalSpacing: CGFloat = 8
    }
    
    public let textField = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let descriptionLabel = UILabel()
    private var buttonDot = UIView()
    let dotview = UIView()
    private var spacer = UIView()
    
    public var delegate: UITextFieldDelegate? {
        didSet {
            self.textField.delegate = delegate
        }
    }
    
    private(set) public var maxValue: Int? = nil
    
    // MARK: life cycle
    
    public override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: configure
    
    public func setMaxValue(_ value: Int) {
        textField.maxValue = value
    }
    
    func configureDescription(_ string: String) {
        descriptionLabel.text = string
    }
    
    
    // MARK: setup views
    func setupViews() {
        setupSelf()
        setupTextField(textField)
        setupButton(buttonDot)
        setupConstraints()
        
        textField.text = "00"
    }
    
    func setupSelf() {
        axis = .horizontal
        alignment = .center
        spacing = 8
        
        addArrangedSubview(textField)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(buttonDot)
        addArrangedSubview(spacer)
        
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setCustomSpacing(10, after: buttonDot  )
    }
    
    func setupTextField(_ tf: UITextField) {        
        tf.backgroundColor = UIColor.mg1
        tf.layer.cornerRadius = Sizes.textFieldCorner
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.masksToBounds = true
        
        // Text
        tf.font = UIFont.monospaceNumber
        tf.tintColor = .clear
        tf.keyboardType = .numberPad
    }
    
    func setupButton(_ button: UIView) {
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        
        
        
        dotview.backgroundColor = UIColor.mg1
        dotview.layer.cornerRadius = 6
        dotview.layer.masksToBounds = true

        
        
        button.addSubview(dotview)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionX))
        button.addGestureRecognizer(gesture)
    }
    
    @IBAction func actionX() {
        textField.becomeFirstResponder()
    }
    
    func setupConstraints() {
        buttonDot.translatesAutoresizingMaskIntoConstraints = false
        dotview.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            buttonDot.widthAnchor.constraint(equalTo: textField.heightAnchor),
            buttonDot.heightAnchor.constraint(equalTo: buttonDot.widthAnchor),
            dotview.centerYAnchor.constraint(equalTo: buttonDot.centerYAnchor),
            dotview.centerXAnchor.constraint(equalTo: buttonDot.centerXAnchor),
            dotview.widthAnchor.constraint(equalToConstant: 12),
            dotview.heightAnchor.constraint(equalTo: dotview.widthAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 0),
            spacer.widthAnchor.constraint(equalToConstant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
