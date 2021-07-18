//
//  HellaProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit


public enum ReversableDateMode {
    
    case absolute, relative
    
}

// MARK: - TwoModeSwitchable protocol

public protocol TwoModeSwitchable {
    
    func setModeTo(_ mode: ReversableDateMode)
    
}

// MARK: - InfoPlate Protocol

public protocol DateRepresentable: TwoModeSwitchable {
    
    var date: Date { get set }
    var interval: DateInterval { get set }
    
    func configure(_ dateInterval: DateInterval)
    func configure(_ date: Date)
}

extension DateRepresentable {
    
    func dateIntervalDescription(date: Date) -> String {
        return ""
    }
    
    func dateDescription(date: Date) -> String {
        return ""
    }
    
    func insertSeparators(_ string: String) -> String{
        let array = string.components(separatedBy: ", ")
        let newString: String = array.joined(separator: " • ")
        return newString
    }
    
    func finishString(_ string: String) -> NSAttributedString {
        /// attributed string
        let attributedString = NSMutableAttributedString(string: string)
        
        /// ranges
        let fullRange = NSRange(location: 0, length: string.count)
        
        /// style
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byTruncatingTail
        style.alignment = .left
        attributedString.addAttribute(.paragraphStyle, value: style, range: fullRange)
        
        /// font
        let font = UIFont.F1
        attributedString.addAttribute(.font, value: font, range: fullRange)
        
        /// color
        let color = UIColor.mg2
        attributedString.addAttribute(.foregroundColor, value: color, range: fullRange)
        
        return attributedString
    }
    
}

// MARK: - DatePicker Protocol

public protocol DatePickable: TwoModeSwitchable {
    
    func setDate(_ date: Date)
    func setInterval(_ interval: DateInterval)
    
}

extension DatePickable {
    func dateToInterval(_ date: Date) -> DateInterval? {
        return nil
    }
    
    func intervalToDate(_ dateInterval: DateInterval) -> Date? {
        return nil
    }
}



