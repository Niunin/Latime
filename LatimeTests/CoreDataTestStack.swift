//
//  CoreDataTestStack.swift
//  LatimeTests
//
//  Created by Andrei Niunin on 24.05.2021.
//
import XCTest
import CoreData
@testable import Latime

struct CoreDataTestStack {
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Latime")
        
        let description = persistentContainer.persistentStoreDescriptions.first
        // Use it if you want to work faster without sql persisted store. But batch updates won't work
        // description?.type = NSInMemoryStoreType
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        context = persistentContainer.viewContext
        
        func cleanPersistentStore() {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TimePoint")
            fetch.predicate = NSPredicate.all
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                let _ = try context.execute(request)
            } catch {
                fatalError("Failed to execute request: \(error)")
            }
        }
        
        cleanPersistentStore()
    }
}
