//
//  InspectorPresenter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Object

class InspectPresenter: InspectPresenterProtocol {
    
    // MARK: properties
    
    /// Hierarchy
    weak var view: InspectViewProtocol!
    var router: InspectRouterProtocol!
    var interactor: InspectInteractorProtocol! {
        didSet {
            configureView()
        }
    }
    
    // MARK: configure
    
    func configureView() {
        let model = interactor.model
        let inspectorModel = InspectModel(model)
        view.configure(model: inspectorModel)
    }
    
    // MARK: viper presenter protocol conformance
    
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
    
    func viewUpdated(date: Date) {
        print("")
        interactor.update(date: date)
    }
    
    func viewUpdated(timeInterval: TimeInterval) {
        interactor.update(interval: Int64(timeInterval))
    }
    
    func viewUpdated(title: String?) {
        interactor.update(title: title)
    }
    
    func interactorUpdated(date: Date) {
        view.configure(date: date)
    }
    
    func interactorUpdated(interval: Int64) {
        let timeInterval = TimeInterval(Int(interval))
        view.configure(interval: timeInterval)
    }
    
    func interactorUpdated(image: UIImage?) {
        view.configure(image: image)
    }
    
    
}


