//
//  GlanceContextMenu.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import UIKit.UIAction

// MARK: - Protocol

protocol GlanceContextMenuProtocol {
    
    func performInspect(_ indexPath: IndexPath)
    func performAddSubRow(_ indexPath: IndexPath)
    func performDelete(_ indexPath: IndexPath)
    
}

// MARK: - Protocol Extension

extension GlanceContextMenuProtocol {
    
    func inspectAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "EditTitle".localized,
                        image: UIImage(systemName: "text.cursor")) { _ in
            self.performInspect(indexPath)
        }
    }
    
    func addSubrowAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "AddPhaseTitle".localized,
                        image: UIImage(systemName: "plus.square.on.square")) { _ in
            self.performAddSubRow(indexPath)
        }
    }
    
    func deleteAction(_ indexPath: IndexPath) -> UIAction {
        return UIAction(title: "DeleteTitle".localized,
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive) { _ in
            self.performDelete(indexPath)
        }
    }
    
    func makePhaseMenu(_ indexPath: IndexPath) -> UIMenu {
        let menuItems = [inspectAction(indexPath),deleteAction(indexPath)]
        return UIMenu(title: "", children: menuItems)
    }
    
    func makeParentPointMenu(_ indexPath: IndexPath) -> UIMenu {
        let menuItems = [inspectAction(indexPath),addSubrowAction(indexPath),deleteAction(indexPath)]
        return UIMenu(title: "", children: menuItems)
    }
    
}
