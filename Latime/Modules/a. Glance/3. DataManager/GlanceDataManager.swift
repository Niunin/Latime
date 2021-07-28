//
//  GlanceDataManager.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import CoreData
import UIKit.UIImage

// MARK: - Object

class GlanceCoreDataManager: NSObject {
    
    // MARK: properties
    
    private var context: NSManagedObjectContext!
    private var visibleTimePoints: [TimePoint] = []
    
    // MARK: init - deinit
    
    init(context: NSManagedObjectContext) {
        super.init()
        self.context = context
    }
    
    // MARK: saving
    
    internal func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: methods
    
    internal func fetchTimePoints(with predicate: NSPredicate, first: Bool = false) -> [TimePoint] {
        let request = NSFetchRequest<TimePoint>(entityName: TimePoint.entityName)
        request.predicate = predicate
        request.sortDescriptors = [
            NSSortDescriptor(key: "positionOfParentPoint", ascending: true),
            NSSortDescriptor(key: "parentPoint", ascending: true),
            NSSortDescriptor(key: "positionOfPhase", ascending: true)
        ]
        if first { request.fetchLimit = 1 }
        guard let fetchedTimePoints = try? self.context.fetch(request) else { return [] }
        return fetchedTimePoints
    }
    
    internal func updatePositions(ofParentsPhases parent: TimePoint) {
        let request = NSFetchRequest<TimePoint>(entityName: TimePoint.entityName)
        request.predicate = NSPredicate(format: "parentPoint = %@", parent)
        request.sortDescriptors = [NSSortDescriptor(key: "infoDate", ascending: true)]
        guard let phases: [TimePoint] = try? self.context.fetch(request) else { return }
        parent.positionOfParentAmongPhases = 0
        var positionIndex: Int64 = 1
        for phase in phases {
            phase.positionOfPhase = positionIndex
            if phase.infoDate! < parent.infoDate! {
                parent.positionOfParentAmongPhases = positionIndex
            }
            positionIndex += 1
            
        }
    }
    
}

// MARK: - CRUD Extension

extension GlanceCoreDataManager: GlanceDataManagerProtocol {
    
    // MARK: create
    
    func addParentPoint() -> TimePoint {
        let parentPoint = TimePoint(context: context)
        parentPoint.infoName = ""
        parentPoint.infoDate = Date() + 3600
        parentPoint.infoImage = nil
        parentPoint.isExposed = true
        parentPoint.positionOfParentAmongPhases = 0
        parentPoint.positionOfParentPoint = positionOfLastParentPoint() + 1
        return parentPoint
    }
    
    private func positionOfLastParentPoint() -> Int64 {
        let request = NSFetchRequest<TimePoint>(entityName: "TimePoint")
        request.predicate = NSPredicate(format: "parentPoint = NULL")
        request.sortDescriptors = [NSSortDescriptor(key: "positionOfParentPoint", ascending: false)]
        request.fetchLimit = 1
        guard let fetchedTimePoints = try? self.context.fetch(request) else { return 0 }
        guard let lastParentPoint = fetchedTimePoints.first else { return 0 }
        return lastParentPoint.positionOfParentPoint
    }
    
    func addPhase(toParentAt index: Int) {
        let parent = parent(ofTimePointAt: index)
        let newPhase = TimePoint(context: context)
        newPhase.infoName = "NewPhaseItemTitle".localized
        newPhase.infoDate = dateForNewPhase(ofParent: parent)
        newPhase.positionOfParentPoint = parent.positionOfParentPoint
        newPhase.isExposed = parent.isExposed
        newPhase.parentPoint = parent
        updatePositions(ofParentsPhases: parent)
        saveContext()
    }
    
    private func parent(ofTimePointAt index: Int) -> TimePoint {
        let timePoint = timePoint(at: index)
        if let parent = timePoint.parentPoint {
            return parent
        } else {
            return timePoint
        }
    }
    
    private func dateForNewPhase(ofParent parent: TimePoint) -> Date {
        let firstPhase = earliestPhase(ofParent: parent)
        let newPhaseDate = Date.earliestOfTwo(parent.infoDate, firstPhase?.infoDate)
        let timeShift = -300.0
        return newPhaseDate + timeShift
    }
    
    private func earliestPhase(ofParent parentPoint: TimePoint) -> TimePoint? {
        let predicate = NSPredicate(format: "parentPoint = %@ AND positionOfPhase = 1", parentPoint)
        let phase = fetchTimePoints(with: predicate, first: true)
        return phase.first
    }
    
    // MARK: retreive
    
    func timePoint(at index: Int) -> TimePoint {
        return visibleTimePoints[index]
    }
    
    func numberOfVisiblePhases(forParentAt index: Int) -> Int {
        let parentPoint = timePoint(at: index)
        let predicate = NSPredicate(format: "parentPoint = %@ AND isExposed = YES", parentPoint)
        let visiblePhases = fetchTimePoints(with: predicate)
        return visiblePhases.count
    }
    
    // MARK: update
    
    func updateVisibleTimePoints() -> [TimePoint] {
        let predicate = NSPredicate(format: "parentPoint = NULL OR isExposed = YES")
        visibleTimePoints = fetchTimePoints(with: predicate)
        return visibleTimePoints
    }
    
    func togglePhasesVisibility(forParentAt index: Int) -> (Int?, Bool) {
        let timePoint = timePoint(at: index)
        let (changes, additive) = timePoint.switchPhasesVisibility(context)
        saveContext()
        return (changes, additive)
    }
    
    // MARK: delete
    
    func delete(at index: Int) {
        let timePoint = visibleTimePoints[index]
        let mission = timePoint.parentPoint
        context.delete(timePoint)
        if let mission = mission {
            updatePositions(ofParentsPhases: mission)
        }
        saveContext()
    }
    
}
