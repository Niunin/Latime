//
//  pointView.swift
//  Latime
//
//  Created by Andrei Niunin on 19.06.2021.
//

import UIKit

// MARK: - Object

public class TimePointView: UIView {
    
    private let desctiptionLabel  = UILabel()
    private let timePointLabel = UILabel()
    
    public override func didMoveToSuperview() {
        desctiptionLabel.text = "Desctiption"
        desctiptionLabel.font = UIFont.systemFont(ofSize: 12)
        timePointLabel.text = Date().description
        addSubview(desctiptionLabel)
        addSubview(timePointLabel)
        desctiptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timePointLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let sa = self.safeAreaLayoutGuide
        let constraints = [
            desctiptionLabel.topAnchor.constraint(equalTo: sa.topAnchor, constant: 10),
            desctiptionLabel.leadingAnchor.constraint(equalTo: sa.leadingAnchor,  constant: 20),
            desctiptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: -10),
            
            timePointLabel.topAnchor.constraint(equalTo: desctiptionLabel.lastBaselineAnchor, constant: 8),
            timePointLabel.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: 15),
            timePointLabel.trailingAnchor.constraint(lessThanOrEqualTo: sa.trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setGray() {
        self.desctiptionLabel.textColor = .systemGray3
        self.timePointLabel.textColor = .systemGray3
    }
    
}
