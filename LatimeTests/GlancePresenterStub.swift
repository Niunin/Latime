//
//  GlancePresenterTest.swift
//  LatimeTests
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
@testable import Latime

class GlancePresenterStub: GlancePresenterProtocol {
    
    var numberOfTimepoints: Int? = nil
    var numberOfChanges: Int? = nil
    var isAdditive: Bool = false
    
    func interactorUpdatedData(with result: [TimePoint]) {
        numberOfTimepoints = result.count
    }
    
    func interactorToggledVisibility(ofSubrowsForRowAt: Int, numberOfChanges: Int?, isAdditive: Bool) {
        self.numberOfChanges = numberOfChanges
        self.isAdditive = isAdditive
    }
    
    // Conformance
    var view: GlanceViewProtocol!
    var router: GlanceRouterProtocol!
    var interactor: GlanceInteractorProtocol!
    func reloadData() {}
    func add(subRowToRowAt: IndexPath) {}
    func cellWasTapped(AtRowWith rowAt: IndexPath) {}
    func updateData() {}
    func delete(rowAt: IndexPath) {}
    func showPreferences() {}
    func showInspector(for index: Int?) {}
}
