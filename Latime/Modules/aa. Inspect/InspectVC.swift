//
//  InspectVC.swift
//  Latime
//
//  Created by Andrei Niunin on 12.07.2021.
//

import UIKit

// MARK: - Object

class InspectViewController: UIViewController, InspectViewInterface {
    
    enum Section: String, CaseIterable, Hashable {
        
        case info = "info"
        case smallinfo = "smallinfo"
        case calendar = "calendar"
        case countdown = "countdown"
        case reminder = "reminder"
        
    }
    
    // MARK: properties
    
    /// Hierarchy
    var presenter: InspectPresenterInterface!
    private var model: InspectModel!
    
    /// Views and controls
    var dataSource: UICollectionViewDiffableDataSource<Int, Section>! = nil
    var collectionView: UICollectionView! = nil
    internal lazy var inputContainer = InputContainer(view: self, delegate: self)
    internal var tap: UITapGestureRecognizer!
    
    private var pickedSegment = 0
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeybordHideTapRecognizer()
        collectionView.addKeyboardNotificationsObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.screenWillClose()
        removeGestureRecognizers()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setupInputContainerConstraints()
    }
        
    // MARK: viper view protocol conformance
    
    func configure(model: InspectModel) {
        self.model = model
        
        // FIXME: It should not be here
        // TODO: Separate first and following runs
        if collectionView != nil {
            recon()
        }
        
    }
    
    func recon() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        if  pickedSegment == 0 {
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
    
    func configure(image: UIImage?) {
        inputContainer.setImage(image)
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
        
        // Remove it from here
        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        if pickedSegment == 0 {
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
        let cellRegInfo = UICollectionView.CellRegistration<DateIntervalCell, String> { (cell, indexPath, identifier) in
            cell.backgroundColor = .white
            if identifier == Section.info.rawValue {
                cell.configure(timeInterval: self.model.dateHandler.intervalFromReferenceToResult )
            } else if identifier == Section.smallinfo.rawValue {
                cell.configure(initialDate: self.model.dateHandler.referenceDate )
                cell.configure(resultDate: self.model.dateHandler.resultDate)
            }
        }
        
        let cellRegDate = UICollectionView.CellRegistration<DateCell, Int> { (cell, indexPath, identifier) in
            cell.picker.date = self.model.dateHandler.resultDate
            cell.handler = { [weak self] (date)  in
                self?.presenter.viewUpdated(date: date)
            }
        }
        
        let cellRegCountdown = UICollectionView.CellRegistration<RelativeDateInput, Int> { (cell, indexPath, identifier) in
            
            cell.setTimeInterval(self.model.dateHandler.intervalFromReferenceToResult )
            cell.handler = { [weak self] (interval)  in
                self?.presenter.viewUpdated(timeInterval: interval)
            }
        }
        
        let cellRegText = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
//            cell.label.text = "Custom cell"
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
        self.pickedSegment = segment
        recon()
    }

}

// MARK: View DateInput Delegate

extension InspectViewController: InspectDateInputDelegate {
    
    func intervalChanged(_ interval: TimeInterval) {
        presenter.viewUpdated(timeInterval: interval)
    }
    
    func dateChanged(_ date: Date) {
        presenter.viewUpdated(date: date)
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
        presenter.viewUpdated(title: title)
    }
    
}
