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
    
    private var currentSegment: Int = 0
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    var constraints: [NSLayoutConstraint] = []
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
        
        relativePicker.view.isHidden = true
        absolutePicker.view.isHidden = false
    
    }
 
    func setupContainer(_ contatinerVC: InspectorDatePickerContainer) {
        addChild(contatinerVC)
        contatinerVC.didMove(toParent: self) // Notify Child View Controller
        
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
            view.bottomAnchor.constraint(equalTo: av.bottomAnchor),
            
            rv.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            rv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: rv.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    @IBAction private func segmentDidChange(_ sender: UISegmentedControl!) {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        
        if selectedSegment == 0 {
            relativePicker.view.isHidden = true
            absolutePicker.view.isHidden = false
        } else {
            relativePicker.view.isHidden = false
            absolutePicker.view.isHidden = true
        }
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
    
    func dateChanged(_ date : Date){
    }

}

