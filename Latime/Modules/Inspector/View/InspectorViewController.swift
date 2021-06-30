//
//  InspectorViewController.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit
import CoreData

typealias InspectorDatePickerContainer = InspectorDatePickerProtocol & UIViewController

// MARK: - Object

class InspectorViewController: UIViewController {
    
    var presenter: InspectorPresenterProtocol!
    private var model: InspectorModel!
    
    /// views
    internal var datePickers: [InspectorDatePickerContainer] = []
    internal lazy var inputContainer = InputContainer(view: self, delegate: self)
    internal var tap: UITapGestureRecognizer!
    internal lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.bounds = CGRect(x: 0, y: 0, width: 180, height: 35)
        return segmentedControl
    }()
    
    private var currentSegment: Int = 0
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        inputContainer.configureConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: if there is no title, then delete model
        presenter.screenWillClose()
        removeNotifications()
        removeGestureRecognizers()
    }

    @IBAction private func segmentDidChange(_ sender: UISegmentedControl!) {
        let selectedSegment = segmentedControl.selectedSegmentIndex
        let currentSegment = self.currentSegment
        self.currentSegment = selectedSegment
        
        UIView.animate(withDuration: 0.25) {
            let offsetSign: CGFloat = currentSegment > selectedSegment ? 1 : -1
            self.datePickers[selectedSegment].view.transform = CGAffineTransform.identity
            self.datePickers[currentSegment].view.transform = CGAffineTransform(
                translationX: offsetSign * (self.view.bounds.width),
                y: 0
            )
        }
    }
    
}

// MARK: - Setup Navigation Bar

private extension InspectorViewController {
    
    func setupNavigationBar() {
        let doneButton = UIBarButtonItem( barButtonSystemItem: .done,
                                          target: self, action: #selector(doneButtonAction)
        )
        let removeButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"), style: .plain,
            target: self, action: #selector(removeButtonAction)
        )
        removeButton.tintColor = .systemRed
        navigationItem.leftBarButtonItems = [removeButton]
        navigationItem.rightBarButtonItems = [doneButton]
        navigationController?.navigationBar.tintColor = UIColor.myAccent
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationController?.navigationBar.tintColor = UIColor.myAccent
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "Point in time"
        
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func doneButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeButtonAction() {
        presenter.buttonPressedRemove()
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Setup Views

private extension InspectorViewController {
    
    func setupViews() {
        setupInputContainer()
        setupDatePickers()
        setupSegmentedControl(segmentedControl)
    }
    
    func setupInputContainer() {
        view.addSubview(inputContainer)
        inputContainer.setTitle(model.title)
        inputContainer.setImage(model.image)
    }
    
    func setupDatePickers() {
        datePickers.append(AbsoluteDatePickerViewController())
        datePickers.append(RelativeDatePickerViewController())
        for picker in datePickers {
            addContainer(picker)
            picker.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            picker.delegate = self
            picker.setDate(model.date)
        }
        datePickers.first?.view.transform = CGAffineTransform.identity
    }
    
    func setupSegmentedControl(_ segmentedControl: UISegmentedControl) {
        if datePickers.count < 2 { return }
        
        for index in datePickers.indices {
            let title = datePickers[index].identifier
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

}

// MARK: - InspectorView Protocol

extension InspectorViewController: InspectorViewProtocol {
    
    func configureView(withModel: InspectorModel) {
        self.model = withModel
        if withModel.type != .mission {
            navigationItem.titleView = segmentedControl
        }
    }
    
    func configureView(withImage: UIImage?) {
        inputContainer.setImage(withImage)
    }
    
}

// MARK: - Container views handlers

internal extension InspectorViewController {
    
    func addContainer(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        view.sendSubviewToBack(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self) // Notify Child View Controller
    }

}

// MARK: - UIGestureRecognizer Delegate

extension InspectorViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view?.isDescendant(of: inputContainer) == true ? false : true
    }

}

// MARK: - DatePicker Delegate

extension InspectorViewController: InspectorDatePickerDelegate {
    
    func dateChanged(_ date : Date){
        presenter.update(date: date)
    }

}

