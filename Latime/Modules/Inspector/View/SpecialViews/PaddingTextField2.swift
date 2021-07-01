//
//  paddingTextField.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

class PaddingTextField: UITextField {
    
    private var insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    var maxValue: Int? = nil
    
    // MARK: init
    
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
//        if action == #selector(paste(_:)) ||
//            action == #selector(cut(_:)) ||
//            action == #selector(copy(_:)) ||
//            action == #selector(select(_:)) ||
//            action == #selector(selectAll(_:)) ||
//            action == #selector(delete(_:)) ||
//            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
//            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
//            action == #selector(toggleBoldface(_:)) ||
//            action == #selector(toggleItalics(_:)) ||
//            action == #selector(toggleUnderline(_:)) {
//            return false
//        }
//        return super.canPerformAction(action, withSender: sender)
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
}
