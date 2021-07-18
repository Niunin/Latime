//
//  InspectorInteractor.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Object

class InspectorInteractor {
    
    weak var presenter: InspectPresenterProtocol!
    var dataManager: InspectDataManagerProtocol!
    
    var titleIsEmpty: Bool {
        if dataManager.model.infoName == "" {
            return true
        } else {
            return false
        }
    }
    
    // MARK: init - deinit
    
    init() {
        addNotificationsObservers()
    }
    
    deinit {
        removeNotificationsObservers()
    }
    
    // MARK: Notifications
    
    private func addNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(imageReceived(_:)), name: .pickerImageReady, object: nil)
    }
    
    @IBAction private func imageReceived(_ notification: Notification) {
        guard let image = notification.userInfo?["image"] as? UIImage else { return }
        update(image: image)
    }
    
    private func removeNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: .pickerImageReady, object: nil)
    }
    
    private func postNotificationInspectorFinished() {
        NotificationCenter.default.post(name: .inspectorFinished, object: nil, userInfo: nil)
    }
    
}

// MARK: - InspectorInteractor Protocol

extension  InspectorInteractor: InspectInteractorProtocol {
    
    var model: TimePoint {
        return dataManager.model
    }
    
    func update(title: String?) {
        dataManager.update(title: title!)
    }
    
    func update(date: Date) {
        dataManager.update(date: date)
    }
    
    func update(image: UIImage?) {
        dataManager.update(image: image)
        presenter.configureView(withImage: image)
    }
    
    func delete() {
        dataManager.delete()
    }
    
    func prepareForClosing() {
        // TODO: Create `==` implementation, so you can compare model sates before and after inspection
        // you can accidentally remove all phases of mission
        if titleIsEmpty {
            dataManager.delete()
        }
        postNotificationInspectorFinished()
    }
    
}
