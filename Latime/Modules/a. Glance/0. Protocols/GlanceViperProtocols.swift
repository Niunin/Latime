//
//  GlanceProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import  CoreData.NSManagedObjectContext

// MARK: - Router Protocol

protocol GlanceRouterProtocol: AnyObject {
    
    var entry: GlanceEntryPoint! { get }
    
    static func build( context: NSManagedObjectContext) -> GlanceEntryPoint
    func showPreferences()
    func showInspector(model: TimePoint)
    
}

// MARK: - View Protocol

protocol GlanceViewProtocol: AnyObject {
    
    var presenter: GlancePresenterProtocol! { get set }
    
    func reloadData()
    func update(models: [GlanceModel])
    func remove(rowsAt: [IndexPath])
    func add(rowsTo: [IndexPath])
    
    func increaseIndicator(ofRowAt: IndexPath)
    func decreaseIndicator(ofRowAt: IndexPath, mark: Int)
    func minimizeIndicator(ofRowAt: IndexPath)
    func maximizeIndicator(ofRowAt: IndexPath)
    
}

// MARK: - Presenter Protocol

protocol GlancePresenterProtocol: AnyObject {
    
    var view: GlanceViewProtocol! { get set }
    var router: GlanceRouterProtocol! { get set }
    var interactor: GlanceInteractorProtocol! { get set }
    
    func add(subRowToRowAt: IndexPath)
    func delete(rowAt: IndexPath)
    func reloadData()
    
    func cellWasTapped(AtRowWith: IndexPath)
    func interactorToggledVisibility(ofSubrowsForRowAt: Int, numberOfChanges: Int?, isAdditive: Bool)
    
    func interactorUpdatedData(with: [TimePoint])
    
    func showPreferences()
    func showInspector(for index: Int?)
    
}

// MARK: - Interactor Protocol

protocol GlanceInteractorProtocol: AnyObject {
    
    var presenter: GlancePresenterProtocol! { get set }
    var dataManager: GlanceDataManagerProtocol! { get set }
    
    func addParentPoint() -> TimePoint
    func addPhase(toParentAt index: Int)
    func timePoint(at index: Int) -> TimePoint
    func cellWasTapped(at index: Int)
    func updateModels()
    func delete(timePointAt index: Int)
    
    func numberOfVisiblePhases(forParentAt index: Int) -> Int
    func positionOfPhase(at index: Int) -> Int?
    
}

// MARK: - DataManager Protocol

protocol GlanceDataManagerProtocol: AnyObject {
    
    func addParentPoint() -> TimePoint
    func addPhase(toParentAt index: Int)
    
    func timePoint(at index: Int) -> TimePoint
    func numberOfVisiblePhases(forParentAt index: Int) -> Int
    
    func updateVisibleTimePoints() -> [TimePoint]
    func togglePhasesVisibility(forParentAt index: Int) -> (Int?, Bool)
    
    func delete(at index: Int)
    
}
