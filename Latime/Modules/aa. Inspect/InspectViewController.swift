//
//  File.swift
//  Latime
//
//  Created by Andrei Niunin on 12.07.2021.
//

import UIKit


// MARK: - Object

class InspectViewController: UIViewController {
    
    enum Section: String, CaseIterable, Hashable {
        
        case info = "info"
        case smallinfo = "smallinfo"
        case calendar = "calendar"
        case countdown = "countdown"
        case reminder = "reminder"
        
    }
    
    // MARK: properties
    
    /// Hierarchu
    var presenter: InspectorPresenterProtocol!
    private var model: InspectorModel!
    
    /// Views and controls
    var dataSource: UICollectionViewDiffableDataSource<Int, Section>! = nil
    var collectionView: UICollectionView! = nil
    internal lazy var inputContainer = InputContainer(view: self, delegate: self)
    internal var tap: UITapGestureRecognizer!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.screenWillClose()
        removeNotifications()
        removeGestureRecognizers()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        // FIXME: Bad layout
        inputContainer.configureConstraints()
    }
    
}

// MARK: - InspectorView Protocol

extension InspectViewController: InspectorViewProtocol {
    
    func configureView(withModel: InspectorModel) {
        self.model = withModel
    }
    
    func configureView(withImage: UIImage?) {
        inputContainer.setImage(withImage)
    }
    
}

// MARK: Navigation Controller

extension InspectViewController {
    
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

// MARK: - Layout

extension InspectViewController {
    
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

// MARK: - DataSource

extension InspectViewController {
    
    func configureHierarchy() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self

        view.addSubview(collectionView)
        view.addSubview(inputContainer)
        
        setupInputContainer()
    }
    
    func setupInputContainer() {
//        inputContainer.setTitle(model.title)
//        inputContainer.setImage(model.image)
        inputContainer.setTitle("title")
        inputContainer.setImage(nil)
    }
    
    func configureDataSource() {
        
        let headerReg = UICollectionView.SupplementaryRegistration<TitleSegmentedView>(elementKind: "header-element-kind") {
            (supplementaryView, string, indexPath) in
            
            supplementaryView.delegate = self
        }
        
        registerCells()
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerReg, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        snapshot.appendSections([0])
        snapshot.appendItems([.info])
        
        snapshot.appendSections([1])
        snapshot.appendItems([.calendar, .reminder])
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    func registerCells() {
        let cellRegDate = UICollectionView.CellRegistration<DateCell, Int> { (cell, indexPath, identifier) in
        }
        
        let cellRegText = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
//            cell.label.text = "Custom cell"
        }
        
        let cellRegInfo = UICollectionView.CellRegistration<DateIntervalCell, Int> { (cell, indexPath, identifier) in
            cell.backgroundColor = .white
        }
        
        let cellRegCountdown = UICollectionView.CellRegistration<RelativeDateInput, Int> { (cell, indexPath, identifier) in
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Section>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Section) -> UICollectionViewCell? in
            switch item {
            case .info, .smallinfo:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegInfo, for: indexPath, item: 0)
            case .calendar:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegDate, for: indexPath, item: 1)
            case .countdown:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegCountdown, for: indexPath, item: 2)
            case .reminder:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegText, for: indexPath, item: 3)
            }
        }
    }
    
}

extension InspectViewController: TitleSegmentedDelegate {
    
    func currentSegment(_ segment: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        snapshot.appendSections([0])
        if segment == 0 {
            snapshot.appendItems([.info])
            snapshot.appendSections([1])
            snapshot.appendItems([.calendar, .reminder])
        } else {
            snapshot.appendItems([.smallinfo])
            snapshot.appendSections([1])
            snapshot.appendItems([.countdown, .reminder])
        }
        guard let xCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DateIntervalCell else { return }
        if segment == 0 {
            xCell.setModeTo(.absolute)
        } else {
            xCell.setModeTo(.relative)
        }
        dataSource.apply(snapshot, animatingDifferences: true )
    }
}

// MARK: - UICollectionView Delegate

extension InspectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}


