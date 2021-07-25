//
//  TimelineInteractor.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation

// MARK: Object

class TimelineInteractor: TimelineInteractorProtocol {
    
    var dataManager: TimelineDataManagerProtocol!
    var presenter: TimelinePresenterProtocol!

    // MARK: viper interactor protocol conformance
    
    func updateData() {
        let data = dataManager.updateData()
        presenter.interactorUpdatedData(data)
    }
    
    func timePoint(for index: Int) -> TimePoint {
        dataManager.timePoint(at: index)
    }
    
    func delete(timePointAt index: Int) {
        dataManager.delete(timePointAt: index)
        self.updateData()
    }
    
}
