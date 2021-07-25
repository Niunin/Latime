//
//  InspectorDataManager.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import CoreData
import UIKit.UIImage

// MARK: - Object

class InspectorDataManager: NSObject {
    
    /// Model
    private var context: NSManagedObjectContext!
    private var modelData: TimePoint!
    
    // MARK: init - deinit
    
    init(context: NSManagedObjectContext, model: TimePoint) {
        super.init()
        self.context = context
        self.modelData = model
    }
    
    // MARK: core data saving support
    
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
    
    internal func updatePositions(ofParent parent: TimePoint) {
        let request = NSFetchRequest<TimePoint>(entityName: TimePoint.entityName)
        request.predicate = NSPredicate(format: "parentPoint = %@", parent)
        request.sortDescriptors = [NSSortDescriptor(key: "infoDate", ascending: true)]
        guard let phases: [TimePoint] = try? self.context.fetch(request) else { return }
        
        var positionIndex: Int64 = 1
        parent.positionOfParentAmongPhases = 0
        for phase in phases {
            phase.positionOfPhase = positionIndex
            positionIndex += 1
            if phase.infoDate! < parent.infoDate! {
                parent.positionOfParentAmongPhases = phase.positionOfPhase
            }
        }
    }
    
}

// MARK: - CRUD

extension InspectorDataManager: InspectDataManagerProtocol {
  
    // MARK: retreive
    
    var model: TimePoint {
        self.modelData
    }
    
    // MARK: update
   
    func update(date: Date) {
        modelData.isRelative = false
        modelData.infoDate = date
        if let parent = modelData.parentPoint {
            updatePositions(ofParent: parent)
        }
        saveContext()
    }
    
    func update(interval: Int64) {
        modelData.isRelative = true
        
        guard let relativeTo = modelData.parentPoint?.infoDate else {
            print(" not worked")
            return
        }
        
        print(" worked")
        let date = relativeTo.advanced(by: TimeInterval(Int(interval)))
        modelData.infoDate = date
        saveContext()
    }
    
    func update(title: String) {
        modelData.infoName = title
        saveContext()
    }
    
    func update(image: UIImage?) {
        modelData.infoImage = Data(image)
        saveContext()
    }
    
    // MARK: delete
    
    func delete() {
        context.delete(modelData)
        saveContext()
    }
    
}
