//
//  TimelineProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation
import  CoreData.NSManagedObjectContext

// MARK: - Router Protocol

protocol  TimelineRouterProtocol: AnyObject  {
    
    var entry: TimelineEntryPoint! { get }
    
    static func build(context: NSManagedObjectContext) -> TimelineEntryPoint
    
}

// MARK: - View Protocol

protocol TimelineViewProtocol: AnyObject {
    
    var presenter: TimelinePresenterProtocol! { get set }

    func loadAndApplyData(_ :[TimelineEntity])
    
}

// MARK: - Presenter Protocol

protocol TimelinePresenterProtocol: AnyObject {
    
    var view: TimelineViewProtocol? { get set }
    var router: TimelineRouterProtocol? { get set }
    var interactor: TimelineInteractorProtocol? { get set }
        
    func viewRequested(TapActionForItemAt: IndexPath)
    func viewRequested(DeleteActionForItemAt: IndexPath)
    func viewRequested(InpectActionForItemAt: IndexPath)
    
    func interactorUpdatedData(_ : [TimePoint])

}

// MARK: - Interactor Protocol

protocol TimelineInteractorProtocol: AnyObject {

    var presenter: TimelinePresenterProtocol! { get set }
    var dataManager: TimelineDataManagerProtocol! { get set }
    
    func updateData()
    func timePoint(for index: Int) -> TimePoint
    func delete(timePointAt index: Int)

}

// MARK: - DataManager Protocol

protocol TimelineDataManagerProtocol: AnyObject {
    
    func timePoint(at index: Int) -> TimePoint
    func updateData() -> [TimePoint]
    func delete(timePointAt index: Int)
    
}
