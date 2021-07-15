//
//  File.swift
//  Latime
//
//  Created by Andrei Niunin on 12.07.2021.
//

import UIKit


// MARK: - Object

class OrthogonalScrollBehaviorViewController: UIViewController {
    
    enum Section: String, CaseIterable, Hashable {
        
        case info = "info"
        case smallinfo = "smallinfo"
        case calendar = "calendar"
        case countdown = "countdown"
        case reminder = "reminder"
        
    }
    
    // MARK: properties
    
    var currentSegment: Int? {
        didSet {
            guard  let n =  currentSegment else { return }
            scrollTo(n)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Section>! = nil
    var collectionView: UICollectionView! = nil
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Orthogonal Section Behaviors"
        configureHierarchy()
        configureDataSource()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 700)
        let ip = IndexPath(row: 1, section: 0)
    }
    
    func scrollTo(_ segment: Int) {
        self.collectionView.layoutIfNeeded()
        
        self.collectionView.isPagingEnabled = false
        
        if segment == 0 {
            let ip = IndexPath(row: 0, section: 1)
            self.collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
            
        } else {
            let ip = IndexPath(row: 1, section: 1)
            self.collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
        }
    }
    
    var x: CGFloat = 100
    
}

// MARK: - Layout

extension OrthogonalScrollBehaviorViewController {
    
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

extension OrthogonalScrollBehaviorViewController {
    
    func configureHierarchy() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
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

extension OrthogonalScrollBehaviorViewController: TitleSegmentedDelegate {
    func currentSegment(_ segment: Int) {
        let ip = IndexPath(row: segment, section: 0)
        

        var snapshot = NSDiffableDataSourceSnapshot<Int, Section>()
        snapshot.appendSections([0])
//        snapshot.appendItems([.info])
        if segment == 0 {
            snapshot.appendItems([.info])
            snapshot.appendSections([1])
            snapshot.appendItems([.calendar])
            snapshot.appendItems([.reminder])
            
        } else {
            snapshot.appendItems([.smallinfo])
            snapshot.appendSections([1])
            snapshot.appendItems([.countdown])
            snapshot.appendItems([.reminder])
            
        }
        
        guard let xCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DateIntervalCell else {
            print("goddamn")
            return
        }
        if segment == 0 {
            xCell.setModeTo(.absolute)
        } else {
            xCell.setModeTo(.relative)
        }
        
//        let context = UICollectionViewLayoutInvalidationContext()
//        context.invalidateItems(at: [IndexPath(item: 0, section: 0)])
//        collectionView.collectionViewLayout.invalidateLayout(with: context)
        
        dataSource.apply(snapshot, animatingDifferences: true )
        
        
        
        

        return
        
        //        collectionView.collectionViewLayout.invalidateLayout()
        //        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        
        
        //collectionView.scrollToItem(at: ip, at: .top, animated: true)
        
        
        
        
        //        // ------------------
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DateCell else {
            print("goddamn")
            return
        }
        //        if segment == 0 {
        //            cell.setAsMain(true)
        //        } else {
        //            cell.setAsMain(false)
        //        }
        //        collectionView.collectionViewLayout.invalidateLayout()
        
    }
}

// MARK: - UICollectionView Delegate

extension OrthogonalScrollBehaviorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(" • ")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}


