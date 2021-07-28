//
//  InspectorModel.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Data Structure

struct InspectModel {
    
    var type: ModelType
    var title: String
    var anchorDate: Date?
    var resultDate: Date
    var timeInterval: TimeInterval?
    var relativeTimeInterval: TimeInterval?
    
    var isRelative: Bool
    var image: UIImage?
    
    enum ModelType {
        case mission
        case phase
    }
    
    // MARK: init
    
    init(_ timePoint: TimePoint) {
        type = timePoint.parentPoint == nil ? .mission : .phase
        title = timePoint.infoName ?? "Title abscent"
        
        if let date = timePoint.infoDate {
        }
        
        isRelative = timePoint.isRelative
        
        if let parent = timePoint.parentPoint {
            anchorDate = parent.infoDate
        }
        
        resultDate = timePoint.infoDate ?? Date()+3600
        relativeTimeInterval = resultDate.timeIntervalSince(anchorDate ?? Date())
        timeInterval = resultDate.timeIntervalSince(Date())

//        print("relative interval \(relativeInterval), fromNowINterval \(intervalFromNow) ")

        if let data = timePoint.infoImage {
            image = UIImage(data: data)
        }
    }
    
}
