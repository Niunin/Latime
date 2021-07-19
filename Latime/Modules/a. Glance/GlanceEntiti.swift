//
//  GlanceModel.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Data Structure

struct GlanceModel {
    
    enum ModelType {
        case mission
        case phase
    }
    
    // MARK: properties
    
    var type: ModelType
    var title: String
    var date: Date
    var image: UIImage?
    var numberOfPhases: Int?
    var positionOfParent: Int?
    var closestPhaseIndex: Int?
    
    // MARK: init-deinit
    
    init(type: ModelType, title: String, date: Date, image: UIImage?) {
        self.type = type
        self.title = title
        self.date = date
        self.image = image
    }
    
    init(_ timePoint: TimePoint) {
        type = timePoint.parentPoint == nil ? .mission : .phase
        title = timePoint.infoName ?? "Title abscent"
        date = timePoint.infoDate ?? Date()+3600
        numberOfPhases = timePoint.phasePoints?.count ?? 0
        positionOfParent = Int(timePoint.positionOfParentAmongPhases)
        if let data = timePoint.infoImage {
            image = UIImage(data: data)
        }
    }
    
}
