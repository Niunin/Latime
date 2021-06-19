//
//  Rotor.swift
//  Timeboy
//
//  Created by Andrei Niunin on 15.05.2021.
//

import UIKit

enum RotorStatus {
    
    case shrinked, exposed, onWait

}

protocol RotorScaleDelegate {
    
    func scaleAppeared()
    func scaleDisappeared()
    func valueChanged(to: Int)

}

// MARK: - Object

class RotorScaleView: UIView {
    
    var delegate: RotorScaleDelegate?
    
    /// Layers
    private var tapCircleLayer: CAShapeLayer!
    private var scaleGradientLayer: CAGradientLayer!
    private var scaleMaskingLayer =  CAReplicatorLayer()
    private var scaleMarkLayer =  CAShapeLayer()
    
    /// gesture
    private var gesture: UIPanGestureRecognizer!
    private var delayedTouchesHandler: DispatchWorkItem?
    private var animationDelay: DispatchWorkItem?
    
    private let panToRotateRatio: CGFloat = 200.0
    private var initialTurnAngle: CGFloat = 0.0
    private var accumulatedIndex: CGFloat = 0.0
    private var rotorStatus: RotorStatus = .shrinked
    
    /// Positions
    private let shirnkedCenter =  CGPoint(x: 300, y: 600)
    private let exposedCenter = CGPoint(x: -100, y: 500)
    
    private let rotorWaitTime = 0.65
    private let wheelScale: CGFloat = 2.5
    private let duration: Double  = 0.2
    
    /// Internal
    private let sizeOfMark = CGSize(width: 15, height: 3)
    private let numberOfMarks = 60
    private var sectorSizeInRadians: CGFloat {
        get {
            2 * CGFloat.pi / CGFloat(numberOfMarks)
        }
    }
    private var rotationInRadians: CGFloat = 0.0
    
    // MARK: functions
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        if rotorStatus == .shrinked, tapCircleLayer.frame.contains(point) {
            return true
        } else if rotorStatus == .shrinked {
            return false
        } else {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        stopWaiting()
        stopWaitingAnimation()
        guard let touchPos = touches.first?.location(in: self) else {return}
        if rotorStatus == .shrinked, tapCircleLayer.frame.contains(touchPos) {
            exposeRotor()
        } else if rotorStatus == .onWait {
            exposeRotor()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startWaiting()
    }
    
    // MARK: setup layers
    
    func setupSelf() {
        addPanGesture()
        setupMaskingLayer()
        setupMarkLayer()
        setupGradientLayer()
        setupTapCircleLayer()
        self.layer.addSublayer(scaleGradientLayer)
        self.layer.addSublayer(tapCircleLayer)
    }
    
    private func setupGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.position = self.center
        gradient.bounds = self.bounds
        gradient.masksToBounds = true
        gradient.mask = scaleMaskingLayer
        
        // setup gradient
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.myAccentCG,
            UIColor.myAccentCG,
            UIColor.clear.cgColor,
        ]
        gradient.locations = [0.25, 0.35, 0.45, 0.55]
        gradient.type = .conic
        gradient.startPoint = CGPoint(x: 0.05, y: 0.75)
        gradient.endPoint = CGPoint(x: -1, y: 0.75)
        
        scaleGradientLayer = gradient
    }
    
    private func setupTapCircleLayer() {
        let layer = CAShapeLayer()
        layer.position = shirnkedCenter
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height:  100)
        layer.fillColor = UIColor.myAccentCG
        
        // setup path
        let x = layer.bounds.midX
        let y = layer.bounds.midX
        let path = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                radius: 40, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        layer.path = path.cgPath
        
        tapCircleLayer = layer
    }
    
    private func setupMaskingLayer() {
        scaleMaskingLayer.addSublayer(scaleMarkLayer)
        scaleMaskingLayer.instanceCount = numberOfMarks
        scaleMaskingLayer.instanceTransform = CATransform3DMakeRotation(sectorSizeInRadians, 0, 0, 1)
        scaleMaskingLayer.position = shirnkedCenter
        scaleMaskingLayer.bounds = CGRect(x: 0, y: 0, width: 400, height:  400)
    }
    
    private func setupMarkLayer() {
        let x: CGFloat = 200.0 // x: Bigger x -> Smaller wheel
        let y: CGFloat = scaleMaskingLayer.bounds.width * 0.5 // y: Half of the replicator size.
        scaleMarkLayer.frame.size = sizeOfMark
        scaleMarkLayer.position = CGPoint(x: x, y: y)
        scaleMarkLayer.backgroundColor = UIColor.black.cgColor
    }
    
    // MARK: configure
    
    private func setTurnAngle(_ angle: CGFloat) {
        scaleMaskingLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0)
    }
    
    func startWaiting() {
        rotorStatus = .onWait
        let workItem = DispatchWorkItem { [weak self] in self?.shrinkRotor() }
        delayedTouchesHandler =  workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + rotorWaitTime , execute: workItem)
    }
    
    func startWaitingAnimation() {
        let workItem = DispatchWorkItem { [weak self] in self?.changeStatus() }
        animationDelay =  workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration , execute: workItem)
    }
    
    func stopWaitingAnimation() {
        animationDelay?.cancel()
        animationDelay = nil
    }
    
    func changeStatus() {
        rotorStatus = .shrinked
    }
    
    func stopWaiting() {
        delayedTouchesHandler?.cancel()
        delayedTouchesHandler = nil
    }
    
    private func shrinkRotor() {
        delegate?.scaleDisappeared()
        startWaitingAnimation()
        setXPositionAnimated(for: scaleMarkLayer, value: 180)
        setPositionAnimated(for: scaleMaskingLayer, value: shirnkedCenter)
        tapCircleAnimation(for: tapCircleLayer, opacity: 1, pos: shirnkedCenter, scale: 1)
    }
    
    private func exposeRotor() {
        delegate?.scaleAppeared()
        rotorStatus = .exposed
        setPositionAnimated(for: scaleMaskingLayer, value: exposedCenter)
        setXPositionAnimated(for: scaleMarkLayer, value: 10)
        tapCircleAnimation(for: tapCircleLayer, opacity: 0, pos: exposedCenter, scale: 5)
    }

}

// MARK: - Gestures

private extension RotorScaleView {
    
    func addPanGesture() {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
    }
    
    @IBAction func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        let additionalPanRotation = translation.y/panToRotateRatio
        
        let finalTurnAngle = initialTurnAngle + additionalPanRotation
        
        let sectorAngle = round((CGFloat(2 * Double.pi / Double(numberOfMarks))).rad2deg())
        
        let ggh = -1 * round(finalTurnAngle.rad2deg()) // .truncatingRemainder(dividingBy: markAngle)
        if accumulatedIndex != round(ggh / sectorAngle) {
            accumulatedIndex = round(ggh / sectorAngle)
            setTurnAngle(finalTurnAngle)
            delegate?.valueChanged(to: Int(accumulatedIndex))
        }
        
        if gestureRecognizer.state == .ended {
            initialTurnAngle = finalTurnAngle
        }
    }
    
}

// MARK: - Animations

private extension RotorScaleView {
    
    func tapCircleAnimation(for layer: CALayer, opacity: CGFloat, pos: CGPoint, scale: CGFloat) {
        layer.transform = CATransform3DMakeScale(scale, scale, 1)
        layer.position = pos
        layer.opacity = Float(opacity)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = layer.presentation()?.transform.m11
        scaleAnimation.toValue = layer.transform.m11
        
        let posAnimation = CABasicAnimation(keyPath: "position")
        posAnimation.fromValue = layer.presentation()?.position
        posAnimation.toValue = layer.position
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = layer.presentation()?.opacity
        opacityAnimation.toValue = layer.opacity
        opacityAnimation.duration = duration * 0.5
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnimation, scaleAnimation, posAnimation]
        group.duration = duration
        
        layer.removeAnimation(forKey: "tapgroup")
        layer.add(group, forKey: "tapgroup")
    }
    
    func setXPositionAnimated(for layer: CALayer, value: CGFloat) {
        layer.position.x = value
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = layer.presentation()?.position.x
        animation.toValue = layer.position.x
        animation.duration = duration
        
        layer.removeAnimation(forKey: "position.x")
        layer.add(animation, forKey: "position.x")
    }
    
    func setPositionAnimated(for layer: CALayer, value: CGPoint) {
        layer.position = value
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = layer.presentation()?.position
        animation.toValue = layer.position
        animation.duration = duration
        
        layer.removeAnimation(forKey: "position")
        layer.add(animation, forKey: "position")
    }
    
}
