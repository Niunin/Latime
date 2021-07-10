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
    struct Sizes {
    
        static let corner: CGFloat = 0.0
        static let borderWidth: CGFloat = 0.0
        
        static let topOffset: CGFloat = 0
        static let btmOffset: CGFloat = 0
        static let leadingOffset: CGFloat = 15
        static let trailingOffset: CGFloat = -15
        static let widthOffset: CGFloat = -(leadingOffset + (-trailingOffset))
        static let spacer: CGFloat = 8

    }
    
    // MARK: properties
    
    var presenter: InspectorPresenterProtocol!
    private var model: InspectorModel!
    
    /// views
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    internal var datePicker = CombinedPicker()
    internal var reminder = ReminderView()
    internal lazy var inputContainer = InputContainer(view: self, delegate: self)
    internal var tap: UITapGestureRecognizer!
    
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
        presenter.screenWillClose()
        removeNotifications()
        removeGestureRecognizers()
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
        setupSelf()
        setupDatePickerContainerView(datePicker)
        setupScrollView(scrollView)
        setupStack(stack)
        setupInputContainer()
        
        setupConstraints()
        
        print(scrollView.contentSize)
    }
    
    func setupSelf() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
    }

    func setupInputContainer() {
        view.addSubview(inputContainer)
        inputContainer.setTitle(model.title)
        inputContainer.setImage(model.image)
    }
    
    func setupScrollView(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
//        scrollView.isUserInteractionEnabled = false
        scrollView.canCancelContentTouches = false
        scrollView.addSubview(stack)
    }
    
    func setupStack(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .fill
        // stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(datePicker.view)
        stack.addArrangedSubview(reminder)
    }
    
    func setupDatePickerContainerView(_ container: UIViewController) {
        addChild(container)
        container.didMove(toParent: self) // Notify Child View Controller
    }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = view.layoutMarginsGuide
        let sa = view.safeAreaLayoutGuide
        
        let constaints = [
            scrollView.leadingAnchor.constraint(equalTo: sa.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: sa.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: sa.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: sa.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 900),

//            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Sizes.leadingOffset),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Sizes.trailingOffset),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: Sizes.widthOffset),
//            stack.heightAnchor.constraint(equalToConstant: 800),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ]
        
//        scrollView.contentSize = CGSize(width: 350, height: 800)
        
        NSLayoutConstraint.activate(constaints)
        
//        stack.backgroundColor = .systemGreen
//        scrollView.backgroundColor = .orange
    }
    
}

// MARK: - InspectorView Protocol

extension InspectorViewController: InspectorViewProtocol {
    
    func configureView(withModel: InspectorModel) {
        self.model = withModel
    }
    
    func configureView(withImage: UIImage?) {
        inputContainer.setImage(withImage)
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

