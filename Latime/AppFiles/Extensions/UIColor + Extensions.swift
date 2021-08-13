//
//  UIColor.extension.swift
//  Timeboy
//
//  Created by Andrei Niunin on 19.05.2021.
//

import Foundation
import UIKit.UIColor

// MARK: - UIColor extension

extension UIColor {
    static let mb = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 1)
    static let mg1 = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1)
    static let mg2 = UIColor(hue: 0, saturation: 0, brightness: 0.62, alpha: 1)
    static let mw = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1)
}

// MARK: - UIColor extension

extension UIColor {
    
    private static let myWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    private static let myGray = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    
    static let specGray = UIColor(white: 0.95, alpha: 1)
    
    static let myPink = UIColor(hexString: "FEBDB3")
    static let myBlue = UIColor(hexString: "529FB5")
    static let myGreen = UIColor(hexString: "A0DEA6")
    static let myYellow = UIColor(hexString: "E9B65B")
    static let myRed = UIColor(hexString: "E93F33")
    
    static var myViewBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                switch traits.userInterfaceStyle {
                case .light:
                    return myWhite
                case .dark :
                    return myGray
                default:
                    return myWhite
                }
            }
        } else {
            return myWhite
        }
    }
    
    static var myViewBackgroundCG: CGColor {
        return myViewBackground.cgColor
    }
    
    static var myAccent: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                switch traits.userInterfaceStyle {
                case .light:
                    return myGray
                case .dark :
                    return myWhite
                default:
                    return myGray
                }
            }
        } else {
            return myGray
        }
    }
    
    static var myAccentCG: CGColor {
        return myAccent.cgColor
    }
    
}

// MARK: - HEX

extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
