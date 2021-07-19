//
//  Interactor.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation

// MARK: - Object

class GlanceInteractor: GlanceInteractorProtocol {
    
    // MARK: properties
    
    /// Hierarchy
    var dataManager: GlanceDataManagerProtocol!
    var presenter: GlancePresenterProtocol!
    
    // MARK: init - deinit
    
    init() {
        addCommnutcationNotificationsObservers()
    }
    
    // MARK: viper interactor protocol conformance
    
    func addParentPoint() -> TimePoint {
        let model = dataManager.addParentPoint()
        return model
    }
    
    func addPhase(toParentAt index: Int) {
        dataManager.addPhase(toParentAt: index)
    }
    
    func timePoint(at index: Int) -> TimePoint {
        return dataManager.timePoint(at: index)
    }
    
    func cellWasTapped(at index: Int) {
        let (changes, isAdditive) = dataManager.togglePhasesVisibility(forParentAt: index)
        presenter.interactorToggledVisibility(ofSubrowsForRowAt: index, numberOfChanges: changes, isAdditive: isAdditive)
    }
    
    func updateModels() {
        let model = dataManager.updateVisibleTimePoints()
        presenter.interactorUpdatedData(with: model)
    }
    
    func delete(timePointAt index: Int) {
        dataManager.delete(at: index)
    }
    
    func numberOfVisiblePhases(forParentAt index: Int) -> Int {
        return dataManager.numberOfVisiblePhases(forParentAt: index)
    }
    
    func positionOfPhase(at index: Int) -> Int? {
        let model = dataManager.timePoint(at: index)
        return Int(model.positionOfPhase)
    }
    
}

// MARK: - Setup Notifications

private extension GlanceInteractor {
    
    func addCommnutcationNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(inspectorDidFinish(_:)), name: .inspectorFinished , object: nil)
    }
    
    @IBAction func inspectorDidFinish(_ notification: Notification) {
        self.updateModels()
        presenter.reloadData()
    }
    
}

