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
