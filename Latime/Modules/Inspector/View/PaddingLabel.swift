//
//  PaddingLabel.swift
//  Timeboy
//
//  Created by Andrei Niunin on 17.05.2021.
//

import Foundation

import UIKit

// MARK: - Object

class PaddingLabel: UILabel {
    private var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // MARK: init
    
    required init(withInsets insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
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
