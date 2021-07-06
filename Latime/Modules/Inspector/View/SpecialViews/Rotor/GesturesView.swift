//
//  FesturesView.swift
//  Latime
//
//  Created by Andrei Niunin on 01.07.2021.
//

import UIKit

//extension CGFloat {
//    
//    func rad2deg() -> CGFloat {
//        return self * 180 / .pi
//    }
//    
//}

enum RotorState {
    case shrinked, exposed, onWait
}

public protocol GestureControlDelegate {

    func exposeRotor()
    func hideRotor()
    func rotate(to markIndex: Int)
    func switchRing(to markIndex: Int)
    func offsetRing()

}

// MARK: - Object

public class GesturesControl: UIView {
    
    private struct Sizes {
        
        static let singleMarkOffset: CGFloat = 20
        
    }
    
    private struct Times {
        
        static let rotorWaitTime = 0.65
        static let duration: Double  = 0.2
    }
    
    // MARK: properties
    
    public var delegate: GestureControlDelegate!
    
    /// Layers
    private var buttonView = UIView()
    
    /// gesture
    private var gesture: UIPanGestureRecognizer!
    private var switchGesture: UIPanGestureRecognizer!
    private var delayedTouchesHandler: DispatchWorkItem?
    private var animationDelay: DispatchWorkItem?
    
    private var accumulatedOffset: CGFloat = 0.0
    private var accumulatedIndex: CGFloat = 0.0
    
    private var rotorState: RotorState = .shrinked
    
    private let wheelScale: CGFloat = 2.5

    var switched = false

    private var rotationInRadians: CGFloat = 0.0
    
    // MARK: functions
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        return false
        if rotorState == .shrinked, buttonView.frame.contains(point) {
            return true
        } else if rotorState == .shrinked {
            return false
        } else {
            return true
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        stopWaiting()
        stopWaitingAnimation()
        guard let touchPos = touches.first?.location(in: self) else {return}
        if rotorState == .shrinked, buttonView.frame.contains(touchPos) {
            delegate.exposeRotor()
        } else if rotorState == .onWait {
            delegate.exposeRotor()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startWaiting()
    }
    
    // MARK: setup layers
    
    public func setupSelf() {
        addSubview(buttonView)
        
        setupButtonView()
        setupPanGesture()
        setupTapGesture()

    }
    
    private func setupButtonView() {
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.backgroundColor = .systemGray2
        buttonView.layer.cornerRadius = 10
        buttonView.layer.masksToBounds = true
        
        let constraints = [
            buttonView.widthAnchor.constraint(equalToConstant: 100),
            buttonView.heightAnchor.constraint(equalToConstant: 30),
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
   
    // MARK: configure
    
    private func setTurnAngle(_ angle: CGFloat) {
//        currentScale.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0)
    }
    
    func startWaiting() {
        rotorState = .onWait
        let workItem = DispatchWorkItem {
            [weak self] in self?.delegate.hideRotor()
        }
        delayedTouchesHandler =  workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Times.rotorWaitTime , execute: workItem)
    }
    
    func startWaitingAnimation() {
        let workItem = DispatchWorkItem {
            [weak self] in self?.changeStatus()
        }
        animationDelay =  workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Times.duration , execute: workItem)
    }
    
    func stopWaitingAnimation() {
        animationDelay?.cancel()
        animationDelay = nil
    }
    
    func changeStatus() {
        rotorState = .shrinked
    }
    
    func stopWaiting() {
        delayedTouchesHandler?.cancel()
        delayedTouchesHandler = nil
    }

}

// MARK: - Gestures

private extension GesturesControl {
    
    func setupTapGesture() {
        
    }
    
    func setupPanGesture() {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
    }
    
    @IBAction func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if abs(gestureRecognizer.velocity(in: self).x) > abs(gestureRecognizer.velocity(in: self).y) {
            switchRing(gestureRecognizer)
        } else {
            rotateWheel(gestureRecognizer)
        }
    }
    
    func rotateWheel(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        let translationY = translation.y
        let currentCumulativeOffset = accumulatedOffset + translationY
        let currentIndex = round(currentCumulativeOffset / Sizes.singleMarkOffset)
        if accumulatedIndex != currentIndex {
            accumulatedIndex = currentIndex
            print(accumulatedIndex)
            delegate.rotate(to: Int(accumulatedIndex))
        }
        if gestureRecognizer.state == .ended {
            accumulatedOffset = currentIndex * Sizes.singleMarkOffset
        }
    }
    
    func switchRing(_ gestureRecognizer: UIPanGestureRecognizer){
        
        if switched == false {
            if gestureRecognizer.velocity(in: self).x > 0 {
                delegate.switchRing(to: 2)
            } else {
                delegate.switchRing(to: 1)
            }
            switched = true
        }
        if gestureRecognizer.state == .ended {
            print("switch fin ok")
            switched = false
        }
    }
    
}
