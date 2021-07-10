//
//  UIFont+Extensions.swift
//  Timeboy
//
//  Created by Andrei Niunin on 19.05.2021.
//

import Foundation
import UIKit.UIFont

extension UIFont {
    
    static let F0 = UIFont.systemFont(ofSize: 28, weight: .light)
    static let F1 = UIFont.rounded(ofSize: 20, weight: .regular)
    static let F12 = UIFont.systemFont(ofSize: 20, weight: .regular)
    static let F2 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let F3 = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let F4 = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let F5 = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static let L6 = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let F7 = UIFont.systemFont(ofSize: 10, weight: .semibold)
    static let monospaceNumber  = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
    
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        // not available in iOS12
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
    
}
