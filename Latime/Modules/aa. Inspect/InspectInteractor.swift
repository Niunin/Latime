//
//  InspectorInteractor.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Object

class InspectInteractor: InspectInteractorInterface {    
    
    // MARK: properties
    
    /// Hierarchy
    weak var output: InspectInteractorOutputInterface?
    var dataManager: InspectDataManagerInterface!
    var data: InspectEntity?
    
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
    
    // MARK: viper interactor interface protocol methods
    
    func refreshData()  {
        let model = dataManager.model
        data = InspectEntity(model)
        respond()
    }
    
    func update(title: String?) {
        dataManager.update(title: title!)
    }
    
    func update(date: Date) {
        data?.dateHandler.setResultDate(date)
        saveDate()
        respond()
    }

    func update(interval: Int64) {
        data?.dateHandler.setInterval(TimeInterval(interval))
        saveDate()
        respond()
    }
    
    private func saveDate() {
        dataManager.update(date: data?.dateHandler.resultDate ?? Date())
    }
    
    private func respond() {
        if data != nil {
            output?.interactorUpdatedData(data: data!)
        }
    }
    
    func update(isDependent: Bool) {
    }
    
    func update(image: UIImage?) {
        dataManager.update(image: image)
        output?.interactorUpdated(image: image)
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

// MARK: - Setup Notifications

private extension InspectInteractor {

    func addNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(imageReceived(_:)), name: .pickerImageReady, object: nil)
    }
    
    @IBAction func imageReceived(_ notification: Notification) {
        guard let image = notification.userInfo?["image"] as? UIImage else { return }
        update(image: image)
    }
    
    func removeNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: .pickerImageReady, object: nil)
    }
    
    func postNotificationInspectorFinished() {
        NotificationCenter.default.post(name: .inspectorFinished, object: nil, userInfo: nil)
    }

}
