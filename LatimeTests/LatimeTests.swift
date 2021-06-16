//
//  LatimeTests.swift
//  LatimeTests
//
//  Created by Andrei Niunin on 16.06.2021.
//

import XCTest
@testable import Latime

protocol X: AnyObject {
    
    func timePoint(forCellAt index: Int) -> TimePoint
    
    // TODO: Fix these guys
    func numberOfVisiblePhases(forParentAt index: Int) -> Int
    func indexOfParentPoint(forCellAt index: Int) -> Int?
    func positionOfPhaseAmongPhases(at index: Int) -> Int?
    // --------
    
}

class LatimeTests: XCTestCase {

    var coreDataStack: CoreDataTestStack!
    var dataManager: GlanceDataManagerProtocol!
    var interactor: GlanceInteractorProtocol!
    var presenter: GlancePresenterStub!
    
    override func setUp() {
        super.setUp()
        interactor = GlanceInteractor()
        presenter = GlancePresenterStub()
        coreDataStack = CoreDataTestStack()
        dataManager = GlanceCoreDataManager(context: coreDataStack.context)
        
        interactor.dataManager = dataManager
        interactor.presenter = presenter
    }

    override func tearDown() {
        
        interactor = nil
        presenter = nil
        dataManager = nil
        coreDataStack = nil
        
        super.tearDown()
    }

    func test_create_parent_point() throws {
        let _ = interactor.addParentPoint()
        interactor.updateModels()
        XCTAssertEqual(presenter.numberOfTimepoints, 1)
    }

    func test_create_phase() throws {
        let _ = interactor.addParentPoint()
        interactor.updateModels()
        interactor.addPhase(toParentAt: 0)
        interactor.updateModels()
        XCTAssertEqual(presenter.numberOfTimepoints, 2)
    }
    
    func test_hide_phases() throws {
        let _ = interactor.addParentPoint()
        interactor.updateModels()
        interactor.addPhase(toParentAt: 0)
        interactor.updateModels()
        interactor.addPhase(toParentAt: 0)
        interactor.updateModels()
        interactor.cellWasTapped(at: 0)
        XCTAssertEqual(presenter.numberOfChanges, 2)
        XCTAssertFalse(presenter.isAdditive)
    }
    
    func test_delete_phase() throws {
        let _ = interactor.addParentPoint()
        interactor.updateModels()
        interactor.addPhase(toParentAt: 0)
        interactor.updateModels()
        interactor.delete(timePointAt: 1)
        interactor.updateModels()
        XCTAssertEqual(presenter.numberOfTimepoints, 1)
    }
    
    func test_delete_parent_point() throws {
        let _ = interactor.addParentPoint()
        interactor.updateModels()
        interactor.addPhase(toParentAt: 0)
        interactor.updateModels()
        interactor.delete(timePointAt: 0)
        interactor.updateModels()
        XCTAssertEqual(presenter.numberOfTimepoints, 0)
    }

}
