//
//  TimelineProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation
import  CoreData.NSManagedObjectContext

// MARK: - Router
protocol  TimelineRouterProtocol: AnyObject  {
    
    var entry: TimelineEntryPoint! { get }
    
    static func build(context: NSManagedObjectContext) -> TimelineEntryPoint
    
}

// MARK: - View

protocol TimelineViewProtocol: AnyObject {
    
    var presenter: TimelinePresenterProtocol! { get set }
    
}

// MARK: - Presenter

protocol TimelinePresenterProtocol: AnyObject {
    
    var view: TimelineViewProtocol! { get set }
    var router: TimelineRouterProtocol! { get set }
    var interactor: TimelineInteractorProtocol! { get set }
    
}

// MARK: - Interactor

protocol TimelineInteractorProtocol: AnyObject {
    
    var presenter: TimelinePresenterProtocol! { get set }
    var dataManager: TimelineDataManagerProtocol! { get set }
    
}

// MARK: - DataManager

protocol TimelineDataManagerProtocol: AnyObject {
    
}
