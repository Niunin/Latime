//
//  InspectorRouter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit
import CoreData

typealias inspectorEntryPoint = InspectorViewProtocol & UIViewController

// MARK: - Object

class InspectorRouter {
    
    weak var entry: inspectorEntryPoint!
    
    // MARK: build
    
    static func build(context: NSManagedObjectContext,
                      model: TimePoint
    ) -> inspectorEntryPoint {
        let router = InspectorRouter()
        let view = InspectorViewController()
        let presenter = InspectorPresenter()
        let interactor = InspectorInteractor()
        let dataManager = InspectorDataManager(context: context, model: model)
        
        view.presenter = presenter
        
        router.entry = view as inspectorEntryPoint
        
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
}

// MARK: - InspectorRouter Protocol

extension InspectorRouter: InspectorRouterProtocol {
    
    func showImagePicker() {
//        let viewController = UnsplashRouter.build()
//        let navigationController =  UINavigationController(rootViewController: viewController)
//        navigationController.navigationBar.topItem?.title  = "Unsplash picker"
//        entry.present(navigationController, animated: true)
    }
    
}
