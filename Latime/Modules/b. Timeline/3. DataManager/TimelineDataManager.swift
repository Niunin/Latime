//
//  DataManager.swift
//  Latime
//
//  Created by Andrei Niunin on 19.07.2021.
//

import UIKit
import CoreData

class TimelineCoreDataManager: NSObject, TimelineDataManagerProtocol {
    
    // MARK: properties
    
    private var context: NSManagedObjectContext?
    private var timePoints: [TimePoint] = []
    
    init(context: NSManagedObjectContext) {
        super.init()
        self.context = context
    }
    
    // MARK: saving
    
    internal func saveContext () {
        guard let context = context else { return } // TODO: Error
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: fetching
    
    private func fetchTimePoints(with predicate: NSPredicate) -> [TimePoint] {
        let request = NSFetchRequest<TimePoint>(entityName: TimePoint.entityName)
        request.predicate = predicate
        request.sortDescriptors = [ NSSortDescriptor(key: "infoDate", ascending: true), ]
        guard let fetchedTimePoints = try? self.context?.fetch(request) else { return [] }
        return fetchedTimePoints
    }
    
    // MARK: viper data manager protocol conformance
    
    func timePoint(at index: Int) -> TimePoint {
        timePoints.last!
    }
    
    func updateData() -> [TimePoint] {
        timePoints = fetchTimePoints(with: .all)
        return timePoints
    }
    
    func delete(timePointAt index: Int) {
        let timePoint = timePoints[index]
        context?.delete(timePoint)
        saveContext()
//       TODO: when deleting phase recount phases indices
    }
    
    
}
