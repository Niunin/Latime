//
//  GlanceRouter.swift
//  Timeboy
//
//  Created by Andrei Niunin on 02.05.2021.
//

import Foundation
import UIKit.UIViewController


typealias UnsplashEntryPoint = UnsplashViewProtocol & UIViewController

// MARK: - Protocol

protocol UnsplashRouterProtocol: AnyObject  {
    
    var entry: UnsplashEntryPoint! { get }
    static func build() -> UnsplashEntryPoint
    func closeCurrentViewController()
    
}

// MARK: - Object

class UnsplashRouter {
    
    // MARK: properties

    weak var entry: UnsplashEntryPoint!
    
    // MARK: build

    static func build() -> UnsplashEntryPoint {
        let view = UnsplashViewController()
        let presenter = UnsplashPresenter()
        let interactor = UnsplashInteractor()
        let router = UnsplashRouter()
        let networker = UnsplashNetworkInterface()
        
        view.presenter = presenter
        
        router.entry = view as UnsplashEntryPoint
        
        interactor.presenter = presenter
        interactor.networkManager = networker
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
    
}

// MARK: - UnsplashRouter Protocol

extension UnsplashRouter: UnsplashRouterProtocol {
    
    func closeCurrentViewController() {
        entry.dismiss(animated: true, completion: nil)
    }
    
}
