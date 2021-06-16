//
//  CoreData+Extensions.swift
//  Timeboy
//
//  Created by Andrei Niunin on 19.05.2021.
//

import Foundation
import UIKit.UIImage
import CoreData


// MARK: - Data Model Extension

extension TimePoint {
    
    static var entityName: String = "TimePoint"
    private var entityName: String {
        TimePoint.entityName
    }
    
    // MARK: instance functions
    
    func switchPhasesVisibility(_ moc: NSManagedObjectContext) -> (Int?, Bool) {
        if self.parentPoint != nil {return (nil, false)}
        self.isExposed.toggle()
        let request = NSBatchUpdateRequest(entityName: self.entityName)
        request.predicate = NSPredicate(format: "parentPoint = %@", self)
        request.propertiesToUpdate = ["isExposed": self.isExposed]
        request.resultType = .updatedObjectIDsResultType
        let numberOfChanges: Int?
        do {
            let result = try moc.execute(request) as? NSBatchUpdateResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            numberOfChanges = objectIDArray?.count
            let changes = [NSUpdatedObjectsKey : objectIDArray as Any] as [AnyHashable : Any]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes , into: [moc])
            return (numberOfChanges, self.isExposed)
        } catch let error {
            fatalError("Failed to execute request: \(error)")
        }
    }

}

// MARK: - NSPredicate extension

extension NSPredicate {

    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")

}

// MARK: - Data extension

extension Data {

    init?(_ image: UIImage?) {
        self.init()
        if let safeImage = image {
            guard let imageData = safeImage.jpegData(compressionQuality: 1) else {
                Swift.debugPrint("CD Image saving error")
                return nil
            }
            self = imageData
        } else {
            return nil
        }
    }

}


