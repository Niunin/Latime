//
//  TimelineRouter.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit
import CoreData

typealias TimelineEntryPoint = TimelineViewProtocol & UIViewController

class TimelineRouter: TimelineRouterProtocol {
    
    weak var entry: TimelineEntryPoint!
    weak var context: NSManagedObjectContext!
    
    // MARK: build
    
    static func build (context: NSManagedObjectContext) -> TimelineEntryPoint {
        let router = TimelineRouter()
        let view = TimelineViewController()
        let presenter = TimelinePresenter()
        let interactor = TimelineInteractor()
        let dateManager = TimelineCoreDataManager(context: context)
        
        view.presenter = presenter
        
        router.entry = view as TimelineEntryPoint
        router.context = context
        
        interactor.presenter = presenter
        interactor.dataManager = dateManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
        
    }
    
    // MARK: viper router protocol conformance
    
}
