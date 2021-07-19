//
//  GlanceViewProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 18.07.2021.
//

import Foundation

// MARK: - Indicator Protocol

protocol IndicatorProtocol {
    
    func minimize()
    func maximize()
    func insertMark(at index: Int)
    func removeMark(at index: Int)
    
}

// MARK: - PhaseCellProtocol

protocol PhaseCellProtocol {
    
    func configure(timePoint: GlanceModel)
    
}

// MARK: - ParentCell Protocol

protocol ParentCellProtocol {

    func configure(timePoint: GlanceModel)
    
    func insertIndicatorMark()
    func removeIndicatorMark(at index: Int)
    func minimizeIndicator()
    func maximizeIndicator()

}


