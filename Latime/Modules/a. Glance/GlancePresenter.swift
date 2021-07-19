//
//  GlancePresenter.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation

// MARK: - Object

class GlancePresenter: GlancePresenterProtocol {
    
    // MARK: properties
    
    /// Hierarchy
    var view: GlanceViewProtocol!
    var router: GlanceRouterProtocol!
    var interactor: GlanceInteractorProtocol! {
        didSet {
            interactor.updateModels()
        }
    }
    
    // MARK: viper presenter protocol conformance

    func add(subRowToRowAt indexPath: IndexPath) {
        let index = indexPath.row
        increaseIndicator(forParentPointAt: index)
        interactor.addPhase(toParentAt: index)
        interactor.updateModels()
        insertRows(forPhasesOfParentAt: index)
    }
    
    private func increaseIndicator(forParentPointAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        view.increaseIndicator(ofRowAt: indexPath)
    }
    
    func reloadData() {
        interactor.updateModels()
        view.reloadData()
    }
    
    func interactorUpdatedData(with result: [TimePoint]) {
        // FIXME: This .map should be the slowest thing ever. And its called really often
        let resultForView: [GlanceModel] = result.map{ GlanceModel($0) }
        view.update(models: resultForView)
    }
    
    private func insertRows(forPhasesOfParentAt index: Int) {
        if interactor.numberOfVisiblePhases(forParentAt: index)>0 {
            let indexPath = IndexPath(row: index+1, section: 0)
            view.add(rowsTo: [indexPath])
        }
    }
    
    func cellWasTapped(AtRowWith indexPath: IndexPath) {
        let index = indexPath.row
        interactor.cellWasTapped(at: index)
    }
    
    func interactorToggledVisibility(ofSubrowsForRowAt index: Int, numberOfChanges: Int?, isAdditive: Bool) {
        guard let changes = numberOfChanges else {return}
        interactor.updateModels()
        let indexPaths = indexPaths(after: index, along: changes)
        if isAdditive {
            view.add(rowsTo: indexPaths)
            view.minimizeIndicator(ofRowAt: IndexPath(item: index, section: 0))
        }  else {
            view.remove(rowsAt: indexPaths)
            view.maximizeIndicator(ofRowAt: IndexPath(item: index, section: 0))
        }
    }
    
    private func indexPaths(after index: Int, along numberOfPhases: Int) -> [IndexPath] {
        if numberOfPhases == 0 {return []}
        var indexPaths: [IndexPath] = []
        for i in 1...numberOfPhases {
            let indexPath = IndexPath(item: index+i, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    func delete(rowAt indexPath: IndexPath) {
        let index = indexPath.row
        let numberOfPhases = interactor.numberOfVisiblePhases(forParentAt: index)
        var indexPaths = indexPaths(after: index, along: numberOfPhases)
        indexPaths.append(indexPath)
        decreaseIndicator(forRemovedPhaseAt: index)
        interactor.delete(timePointAt: index)
        interactor.updateModels()
        view.remove(rowsAt: indexPaths)
    }
    
    private func decreaseIndicator(forRemovedPhaseAt index: Int) {
        guard let positionOfMark = interactor.positionOfPhase(at: index) else {return}
        let missionCellIndex = index - positionOfMark
        let markOffset = positionOfMark - 1
        let missionIndexPath = IndexPath(row: missionCellIndex, section: 0)
        view.decreaseIndicator(ofRowAt: missionIndexPath, mark: markOffset)
    }
    
    func showPreferences() {
        router.showPreferences()
    }
    
    func showInspector(for index: Int?) {
        if let index = index {
            let model = interactor.timePoint(at: index)
            router.showInspector(model: model)
        } else {
            let model = interactor.addParentPoint()
            router.showInspector(model: model)
        }
    }
    
}
