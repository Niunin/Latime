//
//  UIFont+Extensions.swift
//  Timeboy
//
//  Created by Andrei Niunin on 19.05.2021.
//

import Foundation
import UIKit.UIFont

extension UIFont {

    static let fontGiant        = UIFont.preferredFont(forTextStyle: .title1)
    static let fontNoticable    = UIFont.preferredFont(forTextStyle: .title3)
    static let fontNormal       = UIFont.preferredFont(forTextStyle: .headline)
    static let fontButtonTitle  = UIFont.preferredFont(forTextStyle: .subheadline)
    static let fontButtonText   = UIFont.preferredFont(forTextStyle: .title3)
    static let fontSmall        = UIFont.preferredFont(forTextStyle: .footnote)
    static let monospaceNumber  = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
}

// TODO: I need font management
extension UIFont {
    
    static let conuntdownNumber     = UIFont.init(name: "Futura-CondensedExtraBold", size: 32)!
    static let conuntdown2Number    = UIFont.init(name: "Futura-CondensedMedium", size: 32)!
    static let countdownSuffix      = UIFont.init(name: "GillSans", size: 16)!
    static let inputContainerFont   = UIFont.init(name: "GillSans", size: 22)!
    static let phaseLabelFont       = UIFont.init(name: "Futura", size: 14)
    static let parentLabelFont      = UIFont.init(name: "AvenirNext-Medium", size: 18)
    
}

