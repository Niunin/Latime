//
//  UnsplashLogo.swift
//  iX-33
//
//  Created by Andrea Nunti on 12.04.2021.
//

import UIKit

// MARK: - Object

class UnsplashLogo: UIView {
    
    func draw() -> CALayer {
        let logo = UIBezierPath()
        logo.move(to: CGPoint(x: 0, y: 110))
        logo.addLine(to: CGPoint(x: 0, y: 240))
        logo.addLine(to: CGPoint(x: 240, y: 240))
        logo.addLine(to: CGPoint(x: 240, y: 110))
        logo.addLine(to: CGPoint(x: 165, y: 110))
        logo.addLine(to: CGPoint(x: 165, y: 185))
        logo.addLine(to: CGPoint(x: 75, y: 185))
        logo.addLine(to: CGPoint(x: 75, y: 110))
        logo.close()
        
        logo.move(to: CGPoint(x: 75, y: 0))
        logo.addLine(to: CGPoint(x: 75, y: 65))
        logo.addLine(to: CGPoint(x: 165, y: 65))
        logo.addLine(to: CGPoint(x: 165, y: 0))
        logo.close()
        
        let layer = CAShapeLayer()
        layer.path = logo.cgPath
        
        layer.frame = CGRect(x: 10, y: 10, width: 240, height: 240)
        
        layer.fillColor = UIColor.myAccentCG
        layer.lineWidth = 0
        
        return layer
    }

    func imageFromLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
}
