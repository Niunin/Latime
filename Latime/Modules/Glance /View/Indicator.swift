//
//  NewIndicaator.swift
//  Latime
//
//  Created by Andrei Niunin on 28.06.2021.
//

import UIKit

//struct IndicatorDataModel {
//    var numberOfPassedMarks: Int
//    var numberOfShortMarks: Int
//    var indexOfLongMark: Int
//    var isMinimised: Bool
//}

class Indicator2: UIView {
    
    private struct SizeofOfScale {
        
        static let markHeight: CGFloat = 6.0
        static let markCornerRadius: CGFloat = markHeight / 2.0
        static let shortMarkWidth: CGFloat = 6.0
        static let longMarkWidth: CGFloat = 18.0
        
        static let markSpace: CGFloat = 12.0
        static var shortMarkOffset: CGFloat { shortMarkWidth + markSpace }
        static var longMarkOffset: CGFloat { longMarkWidth - shortMarkWidth }
        
    }
    
    private struct TimesOfScaleAnimations {
        static var foldingDuration: Double = 0.2
        static var insertDuration: Double = 0.3
    }
    
    // MARK: properties
    
    override var bounds: CGRect {
        didSet {
            layer.frame = bounds
            setupMarks()
        }
    }
    
    private var numberOfShortMarks: Int = 0
    private var indexOfLongMark: Int = 0
    private var isMinimized: Bool = false
    
    private var shortMarksContainerLayer = CALayer()
    private lazy var longMarkLayer = makeLongMarkLayer()
    
    private var timer: Timer?
    private var runCount = 0
    
    // MARK: init - deinit
    
    convenience init(numberOfShortMarks: Int, indexOfLongMark: Int) {
        self.init()
        self.numberOfShortMarks = numberOfShortMarks
        self.indexOfLongMark = indexOfLongMark
    }

    // MARK: life cycle
    
    override func didMoveToSuperview() {
        setupSelf()
    }
    
    // MARK: configure
    
    func minimize() {
        performMinimize()
    }
    
    func maximize() {
        performMaximize()
    }

    func insertMark(at index: Int = 0) {
        performInsert(at: index)
    }
    
    func removeMark(at index: Int) {
        performRemove(at: index)
    }

}

// MARK: - Setup Layers

private extension Indicator2 {
    
    var shortMarkRect: CGRect {
        CGRect(x: 0, y: 0, width: SizeofOfScale.shortMarkWidth, height: SizeofOfScale.markHeight)
    }
        
    var longMarkRect: CGRect {
        CGRect(x: 0, y: 0, width: SizeofOfScale.longMarkWidth, height: SizeofOfScale.markHeight)
    }
    
    func setupSelf() {
        self.layer.addSublayer(shortMarksContainerLayer)
    }
    
    func setupMarks() {
        setupShortMarksContainerLayer()
        setupLongMark()
    }
    
    func setupShortMarksContainerLayer() {
        shortMarksContainerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shortMarksContainerLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        shortMarksContainerLayer.bounds = self.bounds
        shortMarksContainerLayer.masksToBounds = false
        
        shortMarksContainerLayer.sublayers = []
        for index in 0..<numberOfShortMarks {
            let layer = makeShortMarkLayer(at: index)
            shortMarksContainerLayer.addSublayer(layer)
        }
    }
    
    func makeShortMarkLayer(at index: Int) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.path = markPath(shortMarkRect)
        layer.position = positionOfShortMark(at: index)
        layer.bounds.size = CGSize(width: 6, height: 6)
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }

    private func markPath(_ rect: CGRect) -> CGPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: SizeofOfScale.markCornerRadius).cgPath
    }
    
    func markLayer() -> CAShapeLayer {
        let mark = CAShapeLayer()
        mark.fillColor = UIColor.black.cgColor
        return mark
    }
    
    func positionOfShortMark(at index: Int) -> CGPoint {
        var offset: CGFloat = CGFloat(index) * SizeofOfScale.shortMarkOffset
        if index > indexOfLongMark {
            offset += SizeofOfScale.shortMarkOffset + SizeofOfScale.longMarkOffset
        }
        return CGPoint(x: offset+6, y: 6)
    }
    
    func setupLongMark() {
        self.layer.addSublayer(longMarkLayer)
    }
    
    func makeLongMarkLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.path = markPath(longMarkRect)
        layer.position = positionOfLongMark()
        layer.bounds.size = CGSize(width: 18, height: 6)
        return layer
    }
    
    func positionOfLongMark() -> CGPoint {
        let offset: CGFloat = CGFloat(indexOfLongMark+1) * SizeofOfScale.shortMarkOffset
        return CGPoint(x: offset, y: 3)
    }
    
}

// MARK: perform minimize - maximize

private extension Indicator2 {
    
    func performMinimize() {
        performScaleEffect(0.4)
        isMinimized = true
    }
    
    func performMaximize() {
        performScaleEffect(1)
        isMinimized = false
    }
    
    func performScaleEffect(_ scale: CGFloat) {
        guard let layers = shortMarksContainerLayer.sublayers else { return }
        
        let delay = TimesOfScaleAnimations.foldingDuration/Double(numberOfShortMarks)
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { [self] timer in
            let layer = layers[runCount]
            layer.transform = CATransform3DMakeScale(scale, scale, 1)

            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = layer.presentation()?.transform.m11
            animation.toValue = layer.transform.m11
            animation.toValue = scale
            animation.duration = TimesOfScaleAnimations.foldingDuration

            layer.removeAnimation(forKey: "transform.scale")
            layer.add(animation, forKey: "transform.scale")
            
            self.runCount += 1
            if self.runCount >= numberOfShortMarks {
                timer.invalidate()
                self.runCount = 0
            }
        }
    }
    
}

// MARK: - Perform Insert - Remove

private extension Indicator2 {
    
    func performInsert(at index: Int) {
        let layer = makeShortMarkLayer(at: index)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setCompletionBlock {
            self.shortMarksContainerLayer.insertSublayer(layer, at: UInt32(index))
            self.numberOfShortMarks += 1
            if index <= self.indexOfLongMark {
                self.indexOfLongMark += 1
            }
        }
        offsetMarks(afterMarkAt: index)
        
        CATransaction.commit()
        
    }
    
    func performRemove(at index: Int) {
        guard let layer = shortMarksContainerLayer.sublayers?[index] else { return }
        
        numberOfShortMarks -= 1
        if index <= indexOfLongMark {
            indexOfLongMark -= 1
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setCompletionBlock {
            self.offsetMarks(afterMarkAt: index)
        }
        layer.removeFromSuperlayer()
        CATransaction.commit()
    }
    
    private func offsetMarks(afterMarkAt index: Int) {
        guard let layers = shortMarksContainerLayer.sublayers else { return }
        
        for i in index..<layers.count {
            let layer = layers[i]
            layer.position = positionOfShortMark(at: i)
            
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.fromValue = layer.presentation()?.position.x
            animation.toValue = layer.position.x
            animation.duration = TimesOfScaleAnimations.insertDuration
            
            layer.removeAnimation(forKey: "position.x")
            layer.add(animation, forKey: "position.x")
        }
        longMarkLayer.position = positionOfLongMark()
    }
    
}

