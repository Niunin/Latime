//
//  GlanceTableView.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

// MARK: - Object

class GlanceTableView: UITableView {
    
    private weak var viewController: GlanceViewController!
    
    // MARK: init - deinit
    
    init(_ vc: GlanceViewController) {
        super.init(frame: .zero, style: .plain)
        viewController = vc
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup views and constraints
    
    private func setupSelf() {
        delegate = viewController
        dataSource = viewController
        register(GlanceMissionTVCell.self, forCellReuseIdentifier: GlanceMissionTVCell.identifier)
        register(GlancePhaseTVCell.self, forCellReuseIdentifier: GlancePhaseTVCell.identifier)
        
        dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        backgroundColor = UIColor.myViewBackground
        separatorStyle = .none
    }
    
}
