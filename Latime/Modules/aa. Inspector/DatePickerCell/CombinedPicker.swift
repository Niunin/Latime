//
//  MixedPicker.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit

// MARK: - Object

class CombinedPicker: UIViewController {
    
    // MARK: properties
    
    /// views
    private var segmentedControl = UISegmentedControl()
    private var absolutePicker: InspectorDatePickerContainer = AbsoluteDatePickerViewController()
    private var relativePicker: InspectorDatePickerContainer = RelativeDatePickerViewController()
    
    private var constraints: [NSLayoutConstraint] = []
    
    private var currentSegment: Int = 0
    private var customBottomAnchor = NSLayoutConstraint()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}

// MARK: - Setup Views

private extension CombinedPicker {
    
    func setupViews() {
        setupContainer(relativePicker)
        setupContainer(absolutePicker)
        setupSelf()
        setupSegmentedControl(segmentedControl)
        setupConstraints()
    }
    
    func setupSelf() {
        view.addSubview(segmentedControl)
        view.addSubview(absolutePicker.view)
        view.addSubview(relativePicker.view)
        view.sendSubviewToBack(absolutePicker.view)
        view.sendSubviewToBack(relativePicker.view)
        
        switchPicker(0)
    }
    
    func setupContainer(_ contatinerVC: InspectorDatePickerContainer) {
        addChild(contatinerVC)
        contatinerVC.didMove(toParent: self)
        contatinerVC.delegate = self
        contatinerVC.setDate(Date())
    }
    
    func setupSegmentedControl(_ segmentedControl: UISegmentedControl) {
        segmentedControl.insertSegment(withTitle: "Absolute", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Relative", at: 1, animated: false)
        
        segmentedControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        guard let rv = relativePicker.view,
              let av = absolutePicker.view else { return }
        
        av.translatesAutoresizingMaskIntoConstraints = false
        rv.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            av.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            av.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            av.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            rv.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            rv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            view.bottomAnchor.constraint(greaterThanOrEqualTo: segmentedControl.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func switchPicker(_ activeScreen: Int) {
        customBottomAnchor.isActive = false
        
        guard let rv = relativePicker.view,
              let av = absolutePicker.view else { return }
        
        if activeScreen == 0 {
            rv.isHidden = true
            av.isHidden = false
            customBottomAnchor = view.bottomAnchor.constraint(equalTo: av.bottomAnchor)
        } else {
            rv.isHidden = false
            av.isHidden = true
            customBottomAnchor = view.bottomAnchor.constraint(equalTo: rv.bottomAnchor)
        }
        customBottomAnchor.isActive = true
    }
    
    @IBAction private func segmentDidChange(_ sender: UISegmentedControl!) {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        switchPicker(selectedSegment)
    }
    
}

// MARK: - UIGestureRecognizer Delegate

extension CombinedPicker: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false
    }
    
}

// MARK: - DatePicker Delegate

extension CombinedPicker: InspectorDatePickerDelegate {
    
    func dateChanged(_ date : Date) { }
    
}

