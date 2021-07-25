//
//  TimelineEntity.swift
//  Latime
//
//  Created by Andrei Niunin on 19.07.2021.
//

import Foundation

// MARK: - Data Structure

struct TimelineEntity {
    
    enum EntityKind {
        case parent
        case phase
    }
    
    // MARK: properties
    
    var type: EntityKind
    var title: String
    var date: Date
    var isOverdue: Bool
    var id: Int64
    
    // MARK: init-deinit
    
    init(type: EntityKind, title: String, date: Date, id: Int64) {
        self.type = type
        self.title = title
        self.date = date
        self.id = id
        self.isOverdue = false
        
    }
    
    init(_ timePoint: TimePoint) {
        type = timePoint.parentPoint == nil ? .parent : .phase
        title = timePoint.infoName ?? "No title"
        date = timePoint.infoDate ?? Date()+3600
        isOverdue = date < Date()
        
        id = timePoint.positionOfParentPoint * timePoint.positionOfPhase
    }
    
}
