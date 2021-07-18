//
//  InspectorRouter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit
import CoreData

typealias InspectEntryPoint = InspectViewProtocol & UIViewController

// MARK: - Object

class InspectorRouter {
    
    weak var entry: InspectEntryPoint!
    
    // MARK: build
    
    static func build(context: NSManagedObjectContext,
                      model: TimePoint
    ) -> InspectEntryPoint {
        let router = InspectorRouter()
        let view = InspectViewController()
        let presenter = InspectorPresenter()
        let interactor = InspectorInteractor()
        let dataManager = InspectorDataManager(context: context, model: model)
        
        view.presenter = presenter
        
        router.entry = view as InspectEntryPoint
        
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
}

// MARK: - InspectorRouter Protocol

extension InspectorRouter: InspectRouterProtocol {
    func showCamera() {
        print("camera")
    }
    
    func showUnsplash() {
        print("Unsplash")
//        let viewController = UnsplashRouter.build()
//        let navigationController =  UINavigationController(rootViewController: viewController)
//        navigationController.navigationBar.topItem?.title  = "Unsplash picker"
//        entry.present(navigationController, animated: true)
    }
    
    func showImagePicker() {
        let viewController = ImagePicker()
        viewController.modalPresentationStyle = .formSheet // .formSheet
        viewController.modalTransitionStyle = .coverVertical
        entry.present(viewController, animated: true, completion: nil)
    }
    
}
