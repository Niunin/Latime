//
//  HellaProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit

// MARK: - Enumeration ReversableDateMode

public enum ReversableDateMode {
    case absolute, relative
}

// MARK: - TwoModeSwitchable protocol

protocol TwoModeSwitchable {
    
    func setModeTo(_ mode: ReversableDateMode)
    
}

// MARK: - InfoPlate Protocol

protocol DateRepresentable {
    
    var date: Date { get set }
    var interval: DateInterval { get set }
    
    func configure(timeInterval: TimeInterval)
    func configure(initialDate: Date)
    func configure(resultDate: Date)
    
}

// MARK: Extension to InfoPlate Protocol

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

protocol DatePickable: TwoModeSwitchable {
    
    func setDate(_ date: Date)
    func setInterval(_ interval: DateInterval)
    
}

// MARK: Extension to DatePicker Protocol

extension DatePickable {
    
    func dateToInterval(_ date: Date) -> DateInterval? {
        return nil
    }
    
    func intervalToDate(_ dateInterval: DateInterval) -> Date? {
        return nil
    }
    
}



