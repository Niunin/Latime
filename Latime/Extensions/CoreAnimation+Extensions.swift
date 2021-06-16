//
//  CoreAnimation+Extensions.swift
//  Timeboy
//
//  Created by Andrei Niunin on 19.05.2021.
//

import UIKit

// MARK: - CGFloat extension

extension CGFloat {
    
    func rad2deg() -> CGFloat {
        return self * 180 / .pi
    }
    
}

// MARK: - CGPoint extension

extension CGPoint {

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
    
}
