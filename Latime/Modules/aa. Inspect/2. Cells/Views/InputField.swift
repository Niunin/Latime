//
//  InputCou.swiftntdown.swift
//  Latime
//
//  Created by Andrei Niunin on 15.07.2021.
//
import UIKit

class InputDateField: UIStackView {
    
    // MARK: sizes
    
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
    
    // MARK: properties
    
    weak var delegate: InputCountdownDelegate?
    
    let textField = PaddingTextField(withInsets: Sizes.textFieldInsets)
    private let descriptionLabel = UILabel()
    private var buttonDot = UIView()
    private let dotview = UIView()
    private var spacer = UIView()
    
    private(set) var maxValue: Int? = nil

    // TODO: rename
    private var changeNumber = 0
    var result: Int = 0

    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    // MARK: configure
    
    func setMaxValue(_ value: Int) {
        textField.maxValue = value
    }
    
    func configureDescription(_ string: String) {
        descriptionLabel.text = string
    }
    
}

// MARK: - Setup Views

extension InputDateField {
    
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
        tf.delegate = self
        
        // Text
        tf.font = UIFont.monospaceNumber
        tf.tintColor = .clear
        tf.keyboardType = .numberPad
    }
    
    func setupButton(_ button: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionX))
        
        dotview.backgroundColor = UIColor.mg1
        dotview.layer.cornerRadius = 6
        dotview.layer.masksToBounds = true
        
        button.addSubview(dotview)
        button.addGestureRecognizer(gesture)
    }
    
    @IBAction func actionX() {
        textField.becomeFirstResponder()
    }
    
    func setupConstraints() {
        buttonDot.translatesAutoresizingMaskIntoConstraints = false
        dotview.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonDot.widthAnchor.constraint(equalTo: textField.heightAnchor),
            buttonDot.heightAnchor.constraint(equalTo: buttonDot.widthAnchor),
            dotview.centerYAnchor.constraint(equalTo: buttonDot.centerYAnchor),
            dotview.centerXAnchor.constraint(equalTo: buttonDot.centerXAnchor),
            dotview.widthAnchor.constraint(equalToConstant: 12),
            dotview.heightAnchor.constraint(equalTo: dotview.widthAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 0),
            spacer.widthAnchor.constraint(equalToConstant: 0),
        ])
    }
    
}

// MARK: UI Delegate TextField

extension InputDateField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: fix this color
        textField.layer.borderColor = UIColor.black.cgColor
//        delegate.rectToVisible(textField.frame)
   }
    
    // TODO: refactor textFieldShouldChange
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let ptf = textField as? LimitedTextField, let max = ptf.maxValue {
            var currentText = textField.text ?? ""
            // TODO: rename these vars
            if string == "" {
                currentText.removeLast()
                if currentText == "" {
                    currentText = "00"
                    changeNumber = 0
                } else {
                    currentText = "0" + currentText
                    changeNumber = 1
                }
                textField.text = currentText
            } else {
                switch changeNumber {
                case 1:
                    let firstSign = currentText.last!
                    let newString = String(firstSign) + string
                    if Int(String(newString))! > max {
                        textField.text = "0" + string
                        changeNumber = 1
                    } else {
                        textField.text = newString
                        changeNumber = 0
                    }
                default:
                    textField.text = "0" + string
                    changeNumber = 1
                }
            }
        } else {
            var currentString = textField.text ?? ""
            if string == "" {
                currentString.removeLast()
                textField.text = currentString
            } else {
                textField.text = currentString + string
            }
            if textField.text?.first == "0" {
                textField.text?.removeFirst()
            }
            if textField.text == "" {
                textField.text = "0"
            }
        }
        result = Int(textField.text ?? "0" ) ?? 0
        delegate?.intervalChanged()
        return false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        changeNumber = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        result = Int(textField.text ?? "0" ) ?? 0
    }
    
}
