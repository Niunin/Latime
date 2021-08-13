//
//  InspectorPresenter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Object

class InspectPresenter: InspectPresenterInterface, InspectInteractorOutputInterface {
 
    // MARK: properties
    
    /// Hierarchy
    weak var view: InspectViewInterface!
    var router: InspectRouterInterface!
    var interactor: InspectInteractorInterface! {
        didSet {
            configureView()
        }
    }
    
    // MARK: configure
    
    func configureView() {
        interactor.updateData()
        view.configure(model: interactor.data!)
    }
    
    // MARK: viper presenter interface protocol conformance
    
    func buttonPressedRemove() {
        interactor.delete()
    }
    
    func screenWillClose() {
        interactor.prepareForClosing()
    }
    
    func buttonPressedImagePicker() {
        router.showImagePicker()
    }
    
    func buttonPressedCamera() {
        router.showCamera()
    }
    
    func buttonPressedUnsplash() {
        router.showUnsplash()
    }
    
    func buttonPressedImageRemove() {
        interactor.update(image: nil)
    }
    
    func switchToggledIsDependent(_ isDependent: Bool) {
        interactor.update(isDependent: isDependent)
    }
    
    func viewUpdated(date: Date) {
        interactor.update(date: date)
    }
    
    func viewUpdated(timeInterval: TimeInterval) {
        interactor.update(interval: Int64(timeInterval))
    }
    
    func viewUpdated(title: String?) {
        interactor.update(title: title)
    }
    
    // MARK: viper interactor output interface protocol conformance
    
    func interactorUpdatedData(data: InspectEntity) {
        view.configure(model: data)
    }
    
    func interactorUpdated(image: UIImage?) {
        view.configure(image: image)
        // configureView()
    }
    
    
}


