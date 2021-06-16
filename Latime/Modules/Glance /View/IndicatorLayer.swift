//
//  AnimatedIndicatorView.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

protocol IndicatorProtocol {
    
    func configureInitialState(numberOfMarks: Int, indexOfLongMark: Int)
    func minimizeIndicator()
    func maximizeIndicator()
    func insertMark()
    func removeMark(at position: Int)
    func setFocusTo(markAt: Int)
    
}

// MARK: - Object

class Indicator: CAShapeLayer {
    
    private var numberOfMarks: Int!
    private var positionOfLongMark: Int!
    private var focusedMark: Int?
    
    lazy var shortMarkRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: markWidth, height: markHeight))
    lazy var longMarkRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: longMarkWidth, height: markHeight))
    lazy var shortMarkPath = UIBezierPath(rect: shortMarkRect).cgPath
    lazy var longMarkPath = UIBezierPath(rect: longMarkRect).cgPath
    
    // Size properties
    private let animationDuration: Double  = 0.2
    private let markHeight: CGFloat = 6.0
    private let markWidth: CGFloat = 6.0
    private let longMarkWidth: CGFloat = 18.0
    private let space: CGFloat = 10.0
    private var singleMarkOffset: CGFloat {
        CGFloat(markWidth + space)
    }
    private var longMarkOffset: CGFloat {
        longMarkWidth - markWidth
    }
    
    // MARK: init - deinit
    
    convenience init(_ rect: CGRect) {
        self.init()
        self.frame = rect
    }

}

// MARK: - Indicator Protocol

extension Indicator: IndicatorProtocol {
    
    func configureInitialState(numberOfMarks: Int, indexOfLongMark: Int) {
        self.numberOfMarks = numberOfMarks
        self.positionOfLongMark = indexOfLongMark
        self.drawMarks()
    }
    
    private func drawMarks() {
        self.sublayers = []
        for i in 0...numberOfMarks {
            let path = i==positionOfLongMark ? longMarkPath : shortMarkPath
            let xPosition = xPositionOfMark(at: i)
            
            let mark = makeMarkLayer(with: path)
            mark.position = CGPoint(x: xPosition, y: 0)
            addSublayer(mark)
        }
    }
    
    private func xPositionOfMark(at index: Int) -> CGFloat {
        var accumulatedOffset: CGFloat = 0
        if index > positionOfLongMark {
            accumulatedOffset = CGFloat(index) * singleMarkOffset + longMarkOffset
        } else {
            accumulatedOffset = CGFloat(index) * singleMarkOffset
        }
        return self.bounds.maxX - accumulatedOffset
    }
    
    private func makeMarkLayer(with path: CGPath)->CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.myAccentCG
        layer.lineWidth = 0
        layer.path = path
        return layer
    }
    
    func minimizeIndicator() {
        guard let layers = self.sublayers else { return }
        layers.forEach{ animatePositionY(layer: $0, toValue: 3)}
    }
    
    func maximizeIndicator() {
        guard let layers = self.sublayers else { return }
        layers.forEach{ animatePositionY(layer: $0, toValue: 0)}
    }
    
    func insertMark() {
        positionOfLongMark += 1
        let position = 0
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setCompletionBlock {
            self.drawMark(at: position)
        }
        self.offsetMarks(startingFrom: position, offset: self.singleMarkOffset)
        CATransaction.commit()
    }
    
    private func drawMark(at position: Int) {
        let path = shortMarkPath
        let layer = makeMarkLayer(with: path)
        let longMarkCorrection = position > positionOfLongMark ? longMarkWidth - markWidth : 0
        let xOffset =  CGFloat(position) * singleMarkOffset + longMarkCorrection
        layer.position = CGPoint(x: xOffset, y: 0)
        self.insertSublayer(layer, at: UInt32(position))
    }

    private func offsetMarks(startingFrom start: Int, offset: CGFloat) {
        guard let layers = self.sublayers else { return }
        let end = layers.endIndex
        
        for i in start..<end {
            let mark = layers[i]
            let newPosition = mark.position.x + offset
            animatePositionX(layer: mark, toValue: newPosition)
        }
    }
    
    func removeMark(at position: Int) {
        let positionToDelete = positionConsideringLongMark(forMarkAt: position)
        guard let mark = self.sublayers?[positionToDelete] else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setCompletionBlock {
            self.offsetMarks(startingFrom: positionToDelete, offset: -1 * self.singleMarkOffset)
        }
        mark.removeFromSuperlayer()
        CATransaction.commit()
    }
    
    private func positionConsideringLongMark(forMarkAt position: Int) -> Int {
        if position > positionOfLongMark {
            return position + 1
        } else {
            positionOfLongMark -= 1
            return position
        }
    }

    func setFocusTo(markAt: Int) {
    }

}

// TODO: Refactor this
extension Indicator {
    
    func animatePositionX(layer: CALayer, toValue: CGFloat) {
        layer.position.x = toValue
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = layer.presentation()?.position.x
        animation.toValue = layer.position.x
        animation.duration = animationDuration
        
        layer.removeAnimation(forKey: "position.x")
        layer.add(animation, forKey: "position.x")
    }
    
    func animatePositionY(layer: CALayer, toValue: CGFloat) {
        layer.position.y = toValue
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = layer.presentation()?.position.y
        animation.toValue = layer.position.y
        animation.duration = animationDuration
        
        layer.removeAnimation(forKey: "position.y")
        layer.add(animation, forKey: "position.y")
    }
    
}
