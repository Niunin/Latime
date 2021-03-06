//
//  ICPaddingTextField.swift
//  Latime
//
//  Created by Andrei Niunin on 06.07.2021.
//

import UIKit

// MARK: - Object

class InputConteinerPaddingTextField: UITextField {
    
    private var insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    var maxValue: Int? = nil
    
    // MARK: init-deinit
    
    required init(withInsets insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: insets)
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
    
}
