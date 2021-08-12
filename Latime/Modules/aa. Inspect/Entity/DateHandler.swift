//
//  DateHandler.swift
//  Latime
//
//  Created by Andrei Niunin on 10.08.2021.
//

import Foundation

// MARK: - DateHandler Protocol

protocol DateHandlerProtocol {
    
    /// Dates
    var referenceDate: Date { get }
    var resultDate: Date { get }
    
    /// Intervals
    var intervalFromNowToResult: TimeInterval { get }
    var intervalFromReferenceToResult: TimeInterval { get }
    
    // MARK: methods
    
    mutating func setInterval(_: TimeInterval)
    mutating func setResultDate(_: Date)
    mutating func setReferenceDateType(_: DateHandler.ReferenceType)

}

// MARK: - Data Structure

struct DateHandler: DateHandlerProtocol {
    
    enum ReferenceType {
        case current, parent
    }
    
    //MARK: properties
    
    private var referenceType: ReferenceType = .current
    
    /// reference dates (get only)
    private var currentDate: Date {
        get {
            Date()
        }
    }
    
    private var parentDate: Date?
    
    var referenceDate: Date {
        get {
            if referenceType == .parent, parentDate != nil {
                return parentDate!
            } else   {
                return currentDate
            }
        }
    }
    
    /// result date
    private(set) var resultDate: Date = Date()
    
    /// Intervals
    var intervalFromNowToResult: TimeInterval {
        get {
            DateInterval(start: currentDate, end: resultDate).duration
        }
    }
    
    private(set) var intervalFromReferenceToResult: TimeInterval = 0
    
    //MARK: init
    
    init(resultDate: Date, parentDate: Date? = nil) {
        self.parentDate = parentDate
        self.resultDate = resultDate
        intervalFromReferenceToResult = DateInterval(start: referenceDate, end: resultDate).duration
    }
    
    
    func currentTimeChanged() {
        
    }
    
    // MARK: date work protocol methods
    
    mutating func setReferenceDateType(_ type: ReferenceType) {
        referenceType = type
    }
    
    mutating func setInterval(_ timeInterval: TimeInterval) {
        intervalFromReferenceToResult = timeInterval
        resultDate = DateInterval(start: referenceDate, duration: timeInterval).end
    }
    
    mutating func setResultDate(_ date: Date) {
        resultDate = date
        intervalFromReferenceToResult = DateInterval(start: referenceDate, end: resultDate).duration
    }
    
}
