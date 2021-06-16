//
//  AbsVC.swift
//  iX-33
//
//  Created by Andrea Nunti on 15.04.2021.
//

import UIKit


// MARK: - Object

class RelativeDatePickerViewController: UIViewController {
    
    let identifier: String = "RelativePickerTitle".localized
    weak var delegate: InspectorDatePickerDelegate!
    
    /// views
    private var rotor: RotorScaleView!
    private let dayTitleLabel = UILabel()
    private let daysCounterLabel = UILabel()
    private let daysLabelLayer = CAShapeLayer()
    
    /// internal
    private var labelValue: Int = 0 {
        didSet {
            UIView.transition(with: daysCounterLabel, duration: 0.1, options: .transitionCrossDissolve , animations: { [weak self] in
                guard let self = self else {return}
                self.daysCounterLabel.text = String(-1 * (self.labelValue))
            },
            completion: nil)
        }
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        setupDayTitleLayout(dayTitleLabel)
        setupLabelLayout(daysCounterLabel)
    }
    
    // MARK: setup views
    
    private func setupViews() {
        setupSelf()
        setupRotor()
        setupDayTitleLabel(dayTitleLabel)
        setupDaysCounterLabel(daysCounterLabel)
    }
    
    func setupRotor() {
        self.rotor = RotorScaleView(frame: view.bounds)
        view.addSubview(rotor)
        rotor.delegate = self
        rotor.setupSelf()
    }

    func setupDaysCounterLabel(_ label: UILabel) {
        let stroke: CGFloat = 2.0
        let corner: CGFloat = 5.0
        
        self.view.addSubview(label)
        label.layer.addSublayer(daysLabelLayer)
        label.tintColor = .systemTeal
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = corner
        label.layer.masksToBounds = true
        label.text = "0"
        
        daysLabelLayer.borderColor = UIColor.clear.cgColor
        daysLabelLayer.borderWidth = stroke
        daysLabelLayer.cornerRadius = corner
    }
    
    func setupDayTitleLabel(_ label: UILabel) {
        let stroke: CGFloat = 2.0
        let corner: CGFloat = 5.0
        
        self.view.addSubview(label)
        label.layer.addSublayer(daysLabelLayer)
        label.tintColor = .systemTeal
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = corner
        label.layer.masksToBounds = true
        label.text = "days"
        daysLabelLayer.borderColor = UIColor.clear.cgColor
        daysLabelLayer.borderWidth = stroke
        daysLabelLayer.cornerRadius = corner
    }
    
    func setupLabelLayout(_ label: UILabel) {
        label.frame = CGRect(x: 10, y: 65, width: 60, height: 40)
        label.bounds = CGRect(x: 0, y: 0, width: 60, height: 30)
        daysLabelLayer.bounds.size = daysCounterLabel.bounds.size
        daysLabelLayer.position = CGPoint(x: daysCounterLabel.bounds.midX, y: daysCounterLabel.bounds.midY)
    }
    
    func setupDayTitleLayout(_ label: UILabel) {
        label.frame = CGRect(x: 55, y: 65, width: 70, height: 40)
        label.bounds = CGRect(x: 0, y: 0, width: 60, height: 30)
    }
    
    private func setupSelf() {
        view.backgroundColor = .myViewBackground
    }
    
    // MARK: actions
    
    @IBAction private func dateChanged(_ sender: UIDatePicker) {
        delegate.dateChanged(sender.date)
    }
    
}

// MARK: - RotorScale Delegate

extension RelativeDatePickerViewController: RotorScaleDelegate {
    
    func scaleAppeared() {
        daysLabelLayer.borderColor = UIColor.black.cgColor
    }
    
    func scaleDisappeared() {
        daysLabelLayer.borderColor = UIColor.clear.cgColor
    }
    
    func valueChanged(to value: Int) {
        labelValue = -1 * value
    }
    
}

// MARK: - InspectorDatePicker Protocol

extension RelativeDatePickerViewController: InspectorDatePickerProtocol {
    
    func setDate(_ date: Date) {
    }

}


