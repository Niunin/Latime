//
//  InspectorModel.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Data Structure

struct InspectEntity {
    
    var title: String
    var hasParent: Bool
    var dateHandler: DateHandler
    var image: UIImage?
    
    // MARK: init
    
    init(_ timePoint: TimePoint) {
        
        self.dateHandler = DateHandler(model: timePoint)
        title = timePoint.infoName ?? "Title abscent"
        hasParent = timePoint.parentPoint != nil
        
        if let imageData = timePoint.infoImage {
            image = UIImage(data: imageData)
        }
    }
    
}

// MARK: - Date Data Structure

struct DateHandler {
    
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
    
    init (model: TimePoint) {
        self.parentDate = model.parentPoint?.infoDate
        self.resultDate = model.infoDate!
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
