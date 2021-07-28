//
//  TimelinePresenter.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation

// MARK: Object

class TimelinePresenter: TimelinePresenterProtocol {
    
    var view: TimelineViewProtocol?
    var router: TimelineRouterProtocol?
    var interactor: TimelineInteractorProtocol?  {
        didSet {
            interactor?.updateData()
        }
    }
    
    // MARK: viper presenter protocol conformance
    
    func viewRequested(TapActionForItemAt: IndexPath) {
    }
    
    func viewRequested(DeleteActionForItemAt indexPath: IndexPath) {
        let n: Int = indexPath.item
        interactor?.delete(timePointAt: n)
    }
    
    func viewRequested(InpectActionForItemAt: IndexPath) {
    }
    
    func interactorUpdatedData(_ data: [TimePoint]) {
        // FIXME: This .map should be the slowest thing ever. And its called really often
        let data: [TimelineEntity] = data.map{ TimelineEntity($0) }
        view?.loadAndApplyData(data)
    }
    
}
