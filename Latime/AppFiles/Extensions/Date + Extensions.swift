//
//  ViewController.swift
//  iX-33
//
//  Created by Andrea Nunti on 28.01.2021.
//

import Foundation
import UIKit.UIFont

// MARK: - Date extension

extension Date {
    
    static func earliestOfTwo(_ date1: Date?, _ date2: Date?) -> Date {
        if date1 != nil, date2 == nil {
            return date1!
        } else if date1 == nil, date2 != nil {
            return date2!
        } else if date1 != nil, date2 != nil {
            return ((date1! < date2!) ? date1! : date2!)
        } else {
            return Date()
        }
    }
    
}
