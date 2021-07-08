//
//  GlanceRouter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit
import CoreData

typealias GlanceEntryPoint = GlanceViewProtocol & UIViewController

 
// MARK: - Object

class GlanceRouter {
    
    weak var entry: GlanceEntryPoint!
    weak var context: NSManagedObjectContext!
    
    // MARK: build
    
    static func build(context: NSManagedObjectContext) -> GlanceEntryPoint {
        let router = GlanceRouter()
        let view = GlanceViewController()
        let presenter = GlancePresenter()
        let interactor = GlanceInteractor()
        let dataManager = GlanceCoreDataManager(context: context)
        
        view.presenter = presenter
        
        router.entry = view as GlanceEntryPoint
        router.context = context
        
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
}

// MARK: - GlanceRouter Protocol

extension GlanceRouter: GlanceRouterProtocol {
    
    func showPreferences() {
        //let vc = PreferencesViewController()
        //entry.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showInspector(model: TimePoint) {
        let viewController  = InspectorRouter.build(context: context, model: model)
        let navModalVC =  UINavigationController(rootViewController: viewController)
        navModalVC.modalPresentationStyle = .fullScreen // .formSheet
        navModalVC.modalTransitionStyle = .coverVertical
        entry.present(navModalVC, animated: true, completion: nil)
    }
    
}
