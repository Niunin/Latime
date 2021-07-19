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
    var date: Date
    var image: UIImage?
    
    enum ModelType {
        case mission
        case phase
    }
    
    // MARK: init
    
    init(_ timePoint: TimePoint) {
        type = timePoint.parentPoint == nil ? .mission : .phase
        title = timePoint.infoName ?? "Title abscent"
        date = timePoint.infoDate ?? Date()+3600
        if let data = timePoint.infoImage {
            image = UIImage(data: data)
        }
    }
    
}
