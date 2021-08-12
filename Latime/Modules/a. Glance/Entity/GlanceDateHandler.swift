//
//  GlanceDateHandler.swift
//  Latime
//
//  Created by Andrei Niunin on 12.08.2021.
//

import Foundation

// MARK: - Object
//
//class DateModel {
//
//    private static var start: Date {
//        get {
//            Date()
//        }
//    }
//
//    private static func seconds(in dateComponents: DateComponents ) -> Double {
//        let s = Double(dateComponents.second ?? 0)
//        let m = Double(dateComponents.minute ?? 0)
//        let h = Double(dateComponents.hour ?? 0)
//        let d = Double(dateComponents.day ?? 0)
//        
//        let secondsInMinutes = 60.0 * m
//        let secondsInHours = pow(60,2) * h
//        let secondsInDays = pow(60,2) * 24.0 * d
//        
//        let seconds: Double = s + secondsInMinutes + secondsInHours + secondsInDays
//        return  seconds
//    }
    
//    static func fullDateDescription(from start: Date, to end: Date) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.collapsesLargestUnit = false
//        formatter.allowedUnits = [.day, .hour, .minute]
//        formatter.unitsStyle = .short
//        formatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing, .dropTrailing ]
//        let description = formatter.string(from: start, to: end)!
//        return description
//    }
//
//    static func fullDateDescription(fromNowTo end: Date) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.collapsesLargestUnit = false
//        formatter.allowedUnits = [.day, .hour, .minute]
//        formatter.unitsStyle = .short
//        formatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing, .dropTrailing ]
//        let description = formatter.string(from: start, to: end)!
//        return description
//    }
    
//    static func shortDateDescription(from start: Date, to end: Date) -> String {
//        let prefix = start <= end ? "" : "-"
//        let (safeStart, safeEnd) = (start <= end) ? (start, end) : (end, start)
//        let interval = DateInterval(start: safeStart, end: safeEnd)
//
//        let formatter = DateComponentsFormatter()
//        formatter.collapsesLargestUnit = false
//
//        let secondsInA10Days: Double = 86400 * 10
//        if interval.duration >= secondsInA10Days {
//            formatter.allowedUnits = [.day]
//            formatter.unitsStyle = .full
//        } else {
//            formatter.allowedUnits = [.day, .hour, .minute]
//            formatter.zeroFormattingBehavior = [.dropLeading, .pad, .pad]
//            formatter.unitsStyle = .positional
//
//        }
//        let description = prefix + formatter.string(from: start, to: end)!
//        return description
//    }
    
//    static func dateComponets(from start: Date, to end: Date) -> DateComponents {
//        return Calendar.current.dateComponents([ .day, .hour, .minute], from: start, to: end)
//    }
    
//    static func date(from start: Date, with components: DateComponents) -> Date {
//        let timeOffset = seconds(in: components)
//        return start + timeOffset
//    }
//
//}
