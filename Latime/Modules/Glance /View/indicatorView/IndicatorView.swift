//
//  IndicatorView.swift
//  Latime
//
//  Created by Andrei Niunin on 03.06.2021.
//

import UIKit

// MARK: - Object

class IndicatorView: UIView {
    
    override var bounds: CGRect {
        didSet {
            print("Indicator bounds did set to: \(bounds)")
            layer.frame = bounds
            setup()
        }
    }
    
    /// Layers
    private var linearScaleLayer = CALayer()
    private var aimLayer = CAReplicatorLayer()
    private var aimPartLayer = CAShapeLayer()
    
    /// Information about marks
    private var numberOfMarks: Int = 0
    private var indexOfLongMark: Int = 0
    private var aimedMark: Int = 0
    private var isMinimized: Bool = false
    
    /// mark data
    private var shortMarkPath: CGPath!
    private var longMarkPath: CGPath!
    
    /// Animation
    private var timer: Timer?
    private var runCount = 0
    
    // MARK:
    
//    override var intrinsicContentSize: CGSize {
//        let height = 6
//        let width = Int(CGFloat(numberOfMarks)*(markWidth+space) + longMarkWidth)
//        print(" Indicator intrinsic content size \(width)")
//       return CGSize(width: width * 4, height: height)
//    }

    func setupScaleLayer(_ layer: CALayer) {
        self.layer.addSublayer(layer)

        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        layer.position = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        
        layer.bounds = self.bounds // CGRect(x: 0, y: 0, width: self.bounds.width, height:  6)
        print("ind layer bounds\(layer.bounds)")
//        layer.backgroundColor = UIColor.systemIndigo.cgColor
        
        layer.masksToBounds = true
        layer.sublayers = []
        
        shortMarkPath = makeMarkPath(width: ScaleSizes.markWidth)
        longMarkPath = makeMarkPath(width: ScaleSizes.longMarkWidth)
        for index in 0...numberOfMarks {
            let path: CGPath = index == indexOfLongMark ? longMarkPath : shortMarkPath
            let position: CGPoint = positionOfMark(at: index)
            let mark = makeMarkLayer(at: position, path: path)
            layer.addSublayer(mark)
        }
    }
    
    // MARK: make
    
    private func makeMarkPath(width: CGFloat) -> CGPath {
        let rect = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: width, height: ScaleSizes.markHeight)
        )
        let path = UIBezierPath (
            roundedRect: rect,
            cornerRadius: ScaleSizes.markCornerRadius
        ).cgPath
        return path
    }
    
    private func makeMarkLayer(at position: CGPoint, path: CGPath) -> CAShapeLayer {
        let mark = CAShapeLayer()
        mark.fillColor = UIColor.black.cgColor
        mark.lineWidth = 0
        mark.path = path
        mark.position = position
        return mark
    }
    
    // MARK: configure
    
    func configureInitialState(numberOfMarks: Int, indexOfLongMark: Int, aimedMark: Int) {
        self.numberOfMarks = numberOfMarks
        self.indexOfLongMark = indexOfLongMark
        self.aimedMark = aimedMark
        
        
    }
    
    func setup() {
        setupScaleLayer(linearScaleLayer)
        setupAimLayer()
        setupAimPartLayer()
        // invalidateIntrinsicContentSize()
    }

}

// MARK:

extension IndicatorView {
    
    private func positionOfMark(at index: Int) -> CGPoint {
        let offsetMultiplier = (numberOfMarks) - index
        var offset: CGFloat = linearScaleLayer.bounds.maxX - CGFloat(offsetMultiplier) * ScaleSizes.singleMarkOffset
        offset -= ScaleSizes.markWidth
        offset -= ScaleSizes.longMarkOffset
        if index > indexOfLongMark {
            offset += ScaleSizes.longMarkOffset
        }
        let position = CGPoint(x: offset, y: 0)
        return position
    }
    
    func minimizeIndicator() {
        animateVerticalPositionForMarks(offset: 3)
        shrinkAim()
        isMinimized = true
    }
    
    func maximizeIndicator() {
        animateVerticalPositionForMarks(offset: 0)
        exposeAim()
        isMinimized = false
    }
    
    func animateVerticalPositionForMarks(offset value: CGFloat) {
        guard let layers = linearScaleLayer.sublayers else { return }
        timer?.invalidate()
        self.runCount = 0
        
        let phasesBefore = indexOfLongMark
        let phasesAfter = numberOfMarks - phasesBefore
        
        let maxPhases = max(phasesBefore, phasesAfter)
        let phaseShift = maxPhases - min(phasesBefore,phasesAfter)
        let delay = ScaleAnimationTimes.delayPhaseShift/Double(maxPhases)
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { [self] timer in
            let duration = ScaleAnimationTimes.minimizeDuration
            
            var rhsIndex: Int?
            var lhsIndex: Int?
            
            let fromLeftOnLhs = runCount
            let fromLeftOnRhs = numberOfMarks - runCount + phaseShift
            let fromRightOnLhs = runCount - phaseShift
            let fromRightOnRhs = numberOfMarks - runCount
            
            let onBothSides: Bool = runCount >= phaseShift
            
            if phasesBefore >= phasesAfter, onBothSides == true {
                lhsIndex = fromLeftOnLhs
                rhsIndex = fromLeftOnRhs
            } else if phasesBefore >= phasesAfter {
                lhsIndex = fromLeftOnLhs
            } else if phasesBefore < phasesAfter, onBothSides == true  {
                rhsIndex = fromRightOnRhs
                lhsIndex = fromRightOnLhs
            } else if phasesBefore < phasesAfter {
                rhsIndex = fromRightOnRhs
            }
            
            if let index = rhsIndex {
                self.animatePositionY(layer: layers[index], toValue: value, duration: duration )
            }
            
            if let index = lhsIndex {
                self.animatePositionY(layer: layers[index], toValue: value, duration: duration )
            }

            self.runCount += 1
            if self.runCount >= maxPhases {
                timer.invalidate()
                self.runCount = 0
            }
        }
    }
    
    func animatePositionY(layer: CALayer, toValue: CGFloat, duration: Double = ScaleAnimationTimes.inserDuration) {
        layer.position.y = toValue
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = layer.presentation()?.position.y
        animation.toValue = layer.position.y
        animation.duration = duration
        
        layer.removeAnimation(forKey: "position.y")
        layer.add(animation, forKey: "position.y")
    }
    
    func insertMark(at index: Int = 0) {
        let path: CGPath = shortMarkPath
        let position: CGPoint = positionOfMark(at: 0)
        if index <= indexOfLongMark {
            indexOfLongMark += 1
        }
        numberOfMarks += 1
        
        let mark = makeMarkLayer(at: position, path: path)
        mark.fillColor = UIColor.black.cgColor
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(ScaleAnimationTimes.inserDuration)
        CATransaction.setCompletionBlock {
            self.offsetMarks(forMarkAt: 0, offset: -1 * ScaleSizes.singleMarkOffset)
            
            if self.isMinimized {
                mark.position.y = ScaleSizes.markHalfHeight
                let animation = CAKeyframeAnimation(keyPath: "position.y")
                animation.duration = ScaleAnimationTimes.insertingMarkWhenMinimized
                animation.keyTimes = ScaleAnimationTimes.insertingMarkWhenMinimizedKeyTimes
                animation.values = ScaleSizes.insertingMarkWhenMinimizedValues
                mark.add(animation, forKey:"position.y")
            }
            
            self.updateAimPosition()
            self.aimLayer.transform = CATransform3DMakeRotation(AimSizes.aimRotation, 0, 0, 1)
        }
        self.aimLayer.transform = CATransform3DMakeRotation(AimSizes.pithcAimFront, 0, 0, 1)
        linearScaleLayer.insertSublayer(mark, at: UInt32(index))
        CATransaction.commit()
    }
    
    func removeMark(at position: Int) {
        let positionToDelete = positionConsideringLongMark(forMarkAt: position)
        guard let mark = linearScaleLayer.sublayers?[positionToDelete] else { return }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setCompletionBlock {
            mark.removeFromSuperlayer()
            self.aimLayer.transform = CATransform3DMakeRotation(AimSizes.aimRotation, 0, 0, 1)
            self.handleLongMarkIsInFocus()
        }
        self.offsetMarks(forMarkAt: positionToDelete, offset: ScaleSizes.singleMarkOffset)
        self.numberOfMarks -= 1
        self.updateAimPosition()
        self.aimLayer.transform = CATransform3DMakeRotation(AimSizes.pithcAimBack, 0, 0, 1)
        CATransaction.commit()
    }
    
    private func offsetMarks(forMarkAt end: Int, offset: CGFloat) {
        guard let layers = linearScaleLayer.sublayers else { return }
        for i in 0...end {
            let mark = layers[i]
            let newPosition = mark.position.x + offset
            animatePositionX(layer: mark, toValue: newPosition)
        }
    }
    
    private func animatePositionX(layer: CALayer, toValue: CGFloat) {
        layer.position.x = toValue
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = layer.presentation()?.position.x
        animation.toValue = layer.position.x
        animation.duration = ScaleAnimationTimes.inserDuration
        
        layer.removeAnimation(forKey: "position.x")
        layer.add(animation, forKey: "position.x")
    }
    
    private func positionConsideringLongMark(forMarkAt position: Int) -> Int {
        if position > indexOfLongMark {
            return position + 1
        } else {
            indexOfLongMark -= 1
            return position
        }
    }
    
}

// MARK: Aim layer

extension IndicatorView {
    
    private func setupAimLayer() {
        self.layer.addSublayer(aimLayer)
        aimLayer.addSublayer(aimPartLayer)
        aimLayer.instanceCount = AimSizes.numberOfParts
        aimLayer.instanceTransform = CATransform3DMakeRotation(AimSizes.sectorAngle, 0, 0, 1)
        aimLayer.transform = CATransform3DMakeRotation(AimSizes.aimRotation, 0, 0, 1)
        aimLayer.bounds = AimSizes.bounds
        
        updateAimPosition()
        setupAimPartLayer()
        handleLongMarkIsInFocus()
    }
    
    private func setupAimPartLayer() {
        let x: CGFloat = AimSizes.exposedAim
        let y: CGFloat = aimLayer.bounds.width * 0.5 // y: should be equal to a half of the replicator size.
        aimPartLayer.position = CGPoint(x: x, y: y)
        aimPartLayer.frame.size = AimSizes.sizeOfAimPart
        aimPartLayer.cornerRadius = AimSizes.aimPartCornerRadius
        aimPartLayer.masksToBounds = true
        aimPartLayer.backgroundColor = UIColor.myAccentCG
    }
    
    private func updateAimPosition() {
        aimLayer.position = positionOfMark(at: aimedMark)
        // TODO: Implement it using frame shift
        aimLayer.position.x = aimLayer.position.x + 2.7
        aimLayer.position.y = ScaleSizes.markHalfHeight
        animatePositionX(layer: aimLayer, toValue: aimLayer.position.x)
    }
    
    func handleLongMarkIsInFocus() {
        if aimedMark == indexOfLongMark {
            aimLayer.transform = CATransform3DMakeRotation(AimSizes.aimLongMarkRotation, 0, 0, 1)
        }
    }
    
    private func shrinkAim() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(AimAnimationTimes.shrinkAim)
        
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.duration = AimAnimationTimes.shrinkAim
        animation.keyTimes = AimAnimationTimes.shrinkAimKeyTimes
        animation.values = AimSizes.shrinkingAimValues
        
        aimPartLayer.position.x = AimSizes.shrinkedAim
        aimPartLayer.removeAnimation(forKey: "aimPosition.x")
        aimPartLayer.add(animation, forKey:"aimPosition.x")
        aimLayer.opacity = 0
        CATransaction.commit()
    }
    
    private func exposeAim() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.duration = AimAnimationTimes.exposeAim
        animation.keyTimes = AimAnimationTimes.exposeAimKeyTimes
        animation.values = AimSizes.exposingAimValues
        
        aimPartLayer.position.x = AimSizes.exposedAim
        aimPartLayer.removeAnimation(forKey: "aimPosition.x")
        aimPartLayer.add(animation, forKey:"aimPosition.x")
        aimLayer.opacity = 1
    }
    
    private struct ScaleSizes {
        
        static let markHeight: CGFloat = 6.0
        static let markHalfHeight: CGFloat = markHeight/2
        static let markWidth: CGFloat = 6.0
        static let longMarkWidth: CGFloat = 18.0
        static var markCornerRadius: CGFloat { CGFloat(markHeight) * 0.5 }
        static let space: CGFloat = 10.0
        static var singleMarkOffset: CGFloat {
            CGFloat(markWidth + space)
        }
        static var longMarkOffset: CGFloat {
            longMarkWidth - markWidth
        }
        
        // MinimizedInsert animation
        static let insertingMarkWhenMinimizedValues = [0, markHalfHeight]
        
    }
    
    private struct ScaleAnimationTimes {
        
        static let inserDuration: Double = 0.2
        static let minimizeDuration: Double = 0.2
        static let delayPhaseShift: Double = 0.3
        
        static let insertingMarkWhenMinimized = 0.6
        static let insertingMarkWhenMinimizedKeyTimes: [NSNumber] = [0.2, 0.4]
    }
    
    private struct AimSizes {
        
        static let bounds = CGRect(x: 0, y: 0, width: 30, height:  30)
        
        static let aimRotation: CGFloat = CGFloat.pi / 4.0
        static let aimLongMarkRotation: CGFloat = aimRotation + CGFloat.pi / CGFloat(4)
        static let pithcAimFront = aimRotation + CGFloat.pi / CGFloat(9)
        static let pithcAimBack = aimRotation - CGFloat.pi / CGFloat(11)
        
        static let numberOfParts = 4
        static let sectorAngle = 2 * CGFloat.pi / CGFloat(numberOfParts)
        static let sizeOfAimPart = CGSize(width: 4, height: 2.8)
        static let aimPartCornerRadius = min(sizeOfAimPart.width, sizeOfAimPart.height)/2
        
        // AimPart animation positions
        static let exposedAim: CGFloat = 22
        static let shrinkedAim: CGFloat = 15
        static let bouncedAim: CGFloat = 24
        static let shrinkingAimValues = [exposedAim, bouncedAim, shrinkedAim]
        static let exposingAimValues = [shrinkedAim, bouncedAim, exposedAim]
        
    }
    
    private struct AimAnimationTimes {
        
        static let shrinkAim: Double = 0.6
        static let shrinkAimKeyTimes: [NSNumber] = [0.0, 0.4, 0.6 ]
        
        static let exposeAim: Double = 0.6
        static let exposeAimKeyTimes: [NSNumber] = [0.0, 0.2, 0.6 ]
        
    }
    
}
