//
//  InspectVC.swift
//  Latime
//
//  Created by Andrei Niunin on 12.07.2021.
//

import UIKit

// MARK: - Object

class InspectViewController: UIViewController, InspectViewProtocol {
    
    enum Section: String, CaseIterable, Hashable {
        
        case info = "info"
        case smallinfo = "smallinfo"
        case calendar = "calendar"
        case countdown = "countdown"
        case reminder = "reminder"
        
    }
    
    // MARK: properties
    
    /// Hierarchy
    var presenter: InspectPresenterProtocol!
    private var model: InspectModel!
    
    /// Views and controls
    var dataSource: UICollectionViewDiffableDataSource<Int, Section>! = nil
    var collectionView: UICollectionView! = nil
    internal lazy var inputContainer = InputContainer(view: self, delegate: self)
    internal var tap: UITapGestureRecognizer!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setCurrentSegment(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeybordHideTapRecognizer()
        addKeyboardNotificationsObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.screenWillClose()
        removeNotifications()
        removeGestureRecognizers()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setupInputContainerConstraints()
    }
        
    // MARK: viper view protocol conformance
    
    func configureView(withModel: InspectModel) {
        self.model = withModel
    }
    
    func configureView(withImage: UIImage?) {
        inputContainer.setImage(withImage)
    }

}

// MARK: - Setup Navigation Controller

private extension InspectViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Point in time"
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Point in time"
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

private extension InspectViewController {
    
    func setupViews() {
        setupCollectionView()   // Creates CollectionView
        setupSelf()             // Adds CollectionView and InputContainer
        setupInputContainer()   // Configures CollectionView
    }
    
    func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        registerCells()
        registerHeaders()
    }
    
    func setupSelf() {
        view.addSubview(collectionView)
        view.addSubview(inputContainer)
    }
    
    func setupInputContainer() {
        inputContainer.setTitle(model.title)
        inputContainer.setImage(model.image)
    }
    
    func setupInputContainerConstraints() {
        // FIXME: Bad layout
        inputContainer.configureConstraints()
    }
    
}

// MARK: - Setup Gesture Recognizers

private extension InspectViewController {
    
    func addKeybordHideTapRecognizer() {
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func removeGestureRecognizers() {
        view.removeGestureRecognizer(tap)
    }
    
}

// MARK: - Setup Notifications

private extension InspectViewController {
    
    func addKeyboardNotificationsObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(lowerInputContainer(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(raiseInputContaier(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @IBAction func lowerInputContainer(notification: NSNotification) {
        changeInputContainerHeight(notification, to: 0)
    }
    
    @IBAction func raiseInputContaier(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame?.height ?? 0
        changeInputContainerHeight(notification, to: keyboardHeight)
    }
    
    func changeInputContainerHeight(_ notification: NSNotification, to height: CGFloat) {
        let keyboardAnimationDuration = getKeyboardAnimationDuration(notification)
        inputContainer.setHeight(to: height, with: keyboardAnimationDuration)
    }
    
    func getKeyboardAnimationDuration(_ notification: NSNotification) -> Double? {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        return duration
    }
    
}

// MARK: - Setup CollectionView Layout

private extension InspectViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: "header-element-kind",
            alignment: .top)
        header.pinToVisibleBounds = true
        
        let section0: NSCollectionLayoutSection = {
            let estimatedHeight = CGFloat(50)
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
            return section
        }()
        
        let section1: NSCollectionLayoutSection = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
            return section
        }()
        
        let sectionProvider = { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if section == 0 {
                return section0
            } else {
                return section1
            }
        }
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config)
        return layout
    }
    
}

// MARK: - Setup CollectionView DataSource

private extension InspectViewController {
    
    func registerCells() {
        let cellRegDate = UICollectionView.CellRegistration<DateCell, Int> { (cell, indexPath, identifier) in
        }
        
        let cellRegText = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            //            cell.label.text = "Custom cell"
        }
        
        let cellRegInfo = UICollectionView.CellRegistration<DateIntervalCell, String> { (cell, indexPath, identifier) in
            cell.backgroundColor = .white
            if identifier == Section.info.rawValue {
                cell.setModeTo(.absolute)
            } else {
                cell.setModeTo(.relative)
            }
        }
        
        let cellRegCountdown = UICollectionView.CellRegistration<RelativeDateInput, Int> { (cell, indexPath, identifier) in
            cell.delegate = self
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Section>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Section) -> UICollectionViewCell? in
            switch item {
            case .info, .smallinfo:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegInfo, for: indexPath, item: item.rawValue)
            case .calendar:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegDate, for: indexPath, item: 1)
            case .countdown:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegCountdown, for: indexPath, item: 2)
            case .reminder:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegText, for: indexPath, item: 3)
            }
        }
    }
    
    func registerHeaders() {
        let headerReg = UICollectionView.SupplementaryRegistration<TitleSegmentedView>(elementKind: "header-element-kind") {
            (supplementaryView, string, indexPath) in
            supplementaryView.delegate = self
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerReg, for: index)
        }
    }
    
}

// MARK: - UI Delegate CollectionView

extension InspectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

// MARK: - UI Delegate GestureRecognizer

extension InspectViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view?.isDescendant(of: inputContainer) == true ? false : true
    }
    
}

// MARK: - View Delegate Segmented Control

extension InspectViewController: TitleSegmentedDelegate {
    
    func setCurrentSegment(_ segment: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        if segment == 0 {
            snapshot.appendSections([0])
            snapshot.appendItems([.info])
            snapshot.appendSections([1])
            snapshot.appendItems([.calendar, .reminder])
        } else {
            snapshot.appendSections([0])
            snapshot.appendItems([.smallinfo])
            snapshot.appendSections([1])
            snapshot.appendItems([.countdown, .reminder])
        }
        dataSource.apply(snapshot, animatingDifferences: true )
    }
    
}

// MARK: View DateInput Delegate

extension InspectViewController: InspectDateInputDelegate {
    func rectToVisible(_ rect: CGRect) {
//        collectionView.scrollRectToVisible(rect, animated: true)
        print("˚˚˚˚˚˚˚")
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
//        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)

    }
    
    
    func dateChanged(_ date: Date) {
    
    }
    
}

// MARK: - View Delegate InputContainer

extension InspectViewController: InputContainerDelegate {
    
    @IBAction func callImagePicker() {
        presenter.buttonPressedImagePicker()
    }
    
    func callCamera() {
        presenter.buttonPressedCamera()
    }
    
    func callUnsplash() {
        presenter.buttonPressedUnsplash()
    }
    
    func removeImage() {
        presenter.buttonPressedImageRemove()
    }
    
    func titleUpdated(_ title: String) {
        presenter.update(title: title)
    }
    
}
