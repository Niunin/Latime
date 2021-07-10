//
//  TimelineRouter.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit
import CoreData

typealias TimelineEntryPoint = TimelineViewProtocol & UIViewController

class TimelineRouter {
    
    weak var entry: TimelineEntryPoint!
    weak var context: NSManagedObjectContext!
    
    // MARK: build
    
    static func build (context: NSManagedObjectContext) -> TimelineEntryPoint {
        let router = TimelineRouter()
        let view = TimelineViewController()
        let presenter = TimelinePresenter()
        let interactor = TimelineInteractor()
        
        view.presenter = presenter
        
        router.entry = view as TimelineEntryPoint
        router.context = context
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
        
    }
}

extension TimelineRouter: TimelineRouterProtocol {
    
}
