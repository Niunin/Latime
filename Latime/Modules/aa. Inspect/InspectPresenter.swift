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
        view.configureView(withModel: inspectorModel)
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
    
    func update(date: Date) {
        interactor.update(date: date)
    }
    
    func update(title: String?) {
        interactor.update(title: title)
    }
    
    func configureView(withImage image: UIImage?) {
        view.configureView(withImage: image)
    }
    
}


