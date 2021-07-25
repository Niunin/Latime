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
    var dateRelativeTo: Date?
    var resultDate: Date
    var intervalFromNow: TimeInterval?
    var relativeInterval: TimeInterval?
    
    var isRelative: Bool
    var image: UIImage?
    
//    var type: ModelType
//    var title: String
//    var date: Date
//    var interval: TimeInterval?
//    var isRelative: Bool
//    var image: UIImage?
    
    enum ModelType {
        case mission
        case phase
    }
    
    // MARK: init
    
    init(_ timePoint: TimePoint) {
        type = timePoint.parentPoint == nil ? .mission : .phase
        title = timePoint.infoName ?? "Title abscent"
        isRelative = timePoint.isRelative
        if let parent = timePoint.parentPoint {
            dateRelativeTo = parent.infoDate
        }
        resultDate = timePoint.infoDate ?? Date()+3600
        relativeInterval = TimeInterval(timePoint.infoInterval)
        intervalFromNow = resultDate.timeIntervalSince(dateRelativeTo ?? Date())
        
        if let data = timePoint.infoImage {
            image = UIImage(data: data)
        }
    }
    
}
