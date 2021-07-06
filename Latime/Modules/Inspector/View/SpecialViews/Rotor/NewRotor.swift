//
//  NewRotor.swift
//  Latime
//
//  Created by Andrei Niunin on 01.07.2021.
//

import UIKit

public enum RingMode: Int {
    
    case inner, middle, outer
    
    static func random() -> RingMode {
        let rand = Int.random(in: 0...2)
          return RingMode(rawValue: rand)!
      }
}


class RotorViewProtocol {
    
}

public class RotorView: UIView {
    
    // MARK: sizes
    
    private struct Sizes {

        static let sizeOfMark = CGSize(width: 2, height: 1.5)
        static let sizeOfMarkBig = CGSize(width: 2, height: 2)
        static let numberOfMarks = 90
        
        // TODO: Count these values out of frame
        static var centerPositionForHiddenState: CGPoint = CGPoint(x: 200, y: 600)
        static var centerPositionForExposedState: CGPoint = CGPoint(x: 20, y: 600)
        
        static var sectorInRadians: CGFloat {
            get {
                2 * CGFloat.pi / CGFloat(Sizes.numberOfMarks)
            }
        }
        
    }
    
    private struct AnimationTimes {
        
        static let hideTime: CFTimeInterval = 0.3
        static let exposeTime: CFTimeInterval = 0.3
        static let switchRingTime: CFTimeInterval = 0.3
        
    }
    
    // MARK: properties
    
    private var backgroundLayer = CAGradientLayer()
    private var containerLayer =  CAShapeLayer()
    
    private var ringLayer1 =  CAReplicatorLayer()
    private var ringLayer2 = CAReplicatorLayer()
    private var ringLayer3 = CAReplicatorLayer()
    
    private var markLayer1 =  CAShapeLayer()
    private var markLayer2 = CAShapeLayer()
    private var markLayer3 = CAShapeLayer()
    
    private lazy var activeRing = ringLayer1
    
    public override func didMoveToWindow() {
        setupLayers()
        switchWheelTo(.inner)
    }
    
}

public extension RotorView {
    // MARK: configure
    
    func configure() {
        // Set active wheel
        // Set frame size
    }
    
    func rotateToMark(at index: Int) {
        let angle = CGFloat(index) * Sizes.sectorInRadians
        print(angle)
        activeRing.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0)
    }
    
    func switchWheelTo(_ wheel: RingMode) {
        switch wheel {
        case .inner:
            setRing1()
        case .middle:
            setRing2()
        case .outer:
            setRing3()
        }
    }
    
    func expose() {
        exposeRotor()
    }
    
    func hide() {
        hideRotor()
    }
}

// MARK: Setup Layers

private extension RotorView {
    
    func setupLayers() {
        setupBackgroundLayer(backgroundLayer)
        setupContainerLayer()
        setupSelf()
    }
    
    func setupSelf() {
        self.layer.addSublayer(backgroundLayer)
    }
    
    private func setupBackgroundLayer(_ gradient: CAGradientLayer ) {
        gradient.position = self.center
        gradient.bounds = self.bounds
        gradient.masksToBounds = true
        gradient.mask = containerLayer
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.clear.cgColor,
        ]
        gradient.locations = [0.20, 0.30, 0.45, 0.55]
        gradient.type = .conic
        gradient.startPoint = CGPoint(x: 0.05, y: 0.75)
        gradient.endPoint = CGPoint(x: -1, y: 0.75)
    }
    
    func setupContainerLayer() {
        setupReplicatorLayer(ringLayer1, markLayer1)
        setupReplicatorLayer(ringLayer2, markLayer2)
        setupReplicatorLayer(ringLayer3, markLayer3)
        
        ringLayer1.opacity = 1
        ringLayer2.opacity = 0.6
        ringLayer3.opacity = 0.2
        
        markLayer1.position.x = 370
        markLayer2.position.x = 384
        markLayer3.position.x = 398
        
        markLayer1.frame.size = Sizes.sizeOfMarkBig
        ringLayer2.transform = CATransform3DMakeRotation(Sizes.sectorInRadians/2, 0, 0, 1.0)
        
        containerLayer.position = Sizes.centerPositionForHiddenState
        containerLayer.bounds = CGRect(x: 0, y: 0, width: 400, height:  400)
        containerLayer.addSublayer(ringLayer1)
        
        containerLayer.addSublayer(ringLayer2)
        containerLayer.addSublayer(ringLayer3)
    }
    
    private func setupReplicatorLayer(_ replicatorLayer: CAReplicatorLayer, _ sampleLayer: CAShapeLayer) {
        replicatorLayer.addSublayer(sampleLayer)
        replicatorLayer.instanceCount = Sizes.numberOfMarks
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(Sizes.sectorInRadians, 0, 0, 1)
        replicatorLayer.position = CGPoint(x: 200, y: 200)
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: 400, height:  400)
//        replicatorLayer.backgroundColor = UIColor.systemGray4.cgColor
        
        sampleLayer.position = CGPoint(
            x: 398,                                                         // x: should be more than a half,
            y: 0.5 * (replicatorLayer.bounds.width - Sizes.sizeOfMark.height)) // y: Half of the replicator layer size.
        sampleLayer.frame.size = Sizes.sizeOfMark
        sampleLayer.backgroundColor = UIColor.black.cgColor
    }
    
}

// MARK: Control states

private extension RotorView {
    func setRing1() {
        activeRing = ringLayer1
        setFloatToRing(keypath: \.opacity, 1.0, 0.5, 0.25)
        setCGfloatToMark(keypath: \.position.x, 370, 384+3, 398+3)
    }
    
    func setRing2() {
        activeRing = ringLayer2
        setFloatToRing(keypath: \.opacity, 0.5, 1.0, 0.5)
        setCGfloatToMark(keypath: \.position.x, 370-3, 384, 398+3)
    }
    
    func setRing3() {
        activeRing = ringLayer3
        setFloatToRing(keypath: \.opacity, 0.25, 0.5, 1.0)
        setCGfloatToMark(keypath: \.position.x, 370 - 3, 384 - 3, 398)
    }
    
    func setFloatToRing(keypath: ReferenceWritableKeyPath<CALayer, Float>, _ f1: Float, _ f2: Float, _ f3: Float ) {
        ringLayer1[keyPath: keypath] = f1
        ringLayer2[keyPath: keypath] = f2
        ringLayer3[keyPath: keypath] = f3
    }
    
    func setCGfloatToMark(keypath: ReferenceWritableKeyPath<CALayer, CGFloat>, _ c1: CGFloat, _ c2: CGFloat, _ c3: CGFloat ) {
        markLayer1[keyPath: keypath] = c1
        markLayer2[keyPath: keypath] = c2
        markLayer3[keyPath: keypath] = c3
    }
    
    private func hideRotor() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(AnimationTimes.hideTime)
        CATransaction.setCompletionBlock {
            self.containerLayer.opacity = 0
        }
        
        ringLayer1.transform = CATransform3DMakeRotation(CGFloat.pi*5/4, 0, 0, 1)
        ringLayer2.transform = CATransform3DMakeRotation(CGFloat.pi*4/3, 0, 0, 1)
        ringLayer3.transform = CATransform3DMakeRotation(CGFloat.pi*3/2, 0, 0, 1)
        
        ringLayer1.instanceTransform = CATransform3DMakeRotation(0, 0, 0, 1)
        ringLayer2.instanceTransform = CATransform3DMakeRotation(0, 0, 0, 1)
        ringLayer3.instanceTransform = CATransform3DMakeRotation(0, 0, 0, 1)
        setAndAnimatePosition(for: containerLayer, value: Sizes.centerPositionForHiddenState)
        CATransaction.commit()
    }
    
    private func exposeRotor() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(AnimationTimes.exposeTime)
        CATransaction.setCompletionBlock { }
        setMarkTransform(Sizes.sectorInRadians)
        containerLayer.opacity = 1
        setAndAnimatePosition(for: containerLayer, value: Sizes.centerPositionForExposedState)
        
        ringLayer1.transform = CATransform3DMakeRotation(0, 0, 0, 1)
        ringLayer2.transform = CATransform3DMakeRotation(CGFloat.pi/3, 0, 0, 1)
        ringLayer3.transform = CATransform3DMakeRotation(CGFloat.pi/2, 0, 0, 1)
        CATransaction.commit()
    }
    
    func setMarkTransform(_ value: CGFloat) {
        let transform = CATransform3DMakeRotation(value, 0, 0, 1)
        ringLayer1.instanceTransform = transform
        ringLayer2.instanceTransform = transform
        ringLayer3.instanceTransform = transform
    }
    
    func setAndAnimatePosition(for layer: CALayer, value: CGPoint) {
        layer.position = value
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = layer.presentation()?.position
        animation.toValue = layer.position
        animation.duration = AnimationTimes.switchRingTime
        
        layer.removeAnimation(forKey: "position")
        layer.add(animation, forKey: "position")
    }
}

