//
//  TimelineViewController.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit

// MARK: - Object

class TimelineViewController: UIViewController, TimelineViewProtocol {
    
    // MARK: properties
    
    var presenter: TimelinePresenterProtocol!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var data: [TimelineEntity] = []
    
    // MARK: life cycle
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view = collectionView
    }
    
    override func viewDidLoad() {
        setupViews()
        dataSource.apply(snapshot(), animatingDifferences: true )
    }
    
    // MARK: viper view protocol conformance
    
    func loadAndApplyData(_ data:[TimelineEntity]) {
        self.data = data
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        
        var section1shot: [Int] = []
        var section2shot: [Int] = []
        
        for i in data.indices {
            if data[i].isOverdue {
                section1shot.append(i)
            } else {
                section2shot.append(i)
            }
        }
        
        snapshot.appendSections([0])
        snapshot.appendItems(section1shot)
        snapshot.appendSections([1])
        snapshot.appendItems(section2shot)
        return snapshot
    }
    
}

// MARK: - Setup Veiws

extension TimelineViewController {
    
    func setupViews() {
        setupSelf()
        setupCollectionView(collectionView)
    }
    
    func setupSelf()  {
        view.backgroundColor = .white
    }
    
    func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        registerCells()
        registerHeaders()
    }
    
}


// MARK: - Setup CollectionView Layout

private extension TimelineViewController {
    
    func createLayout() -> UICollectionViewLayout {
        /// Header
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: "header-element-kind",
            alignment: .top)
        header.pinToVisibleBounds = true
        
        /// Size, Lyaout, Item
        let estimatedHeight = CGFloat(50)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        
        /// Sections
        let section0: NSCollectionLayoutSection = {
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
            return section
        }()
        
        let section1: NSCollectionLayoutSection = {
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
            section.boundarySupplementaryItems = [header]
            return section
        }()
        
        /// Section Provider
        let sectionProvider = { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if section == 0 {
                return section0
            } else {
                return section1
            }
        }
        
        /// Configuration
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        /// Layout
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config)
        return layout
    }
    
}

// MARK: - Setup CollectionView DataSource

private extension TimelineViewController {
    
    func registerCells() {
        let cellReg = UICollectionView.CellRegistration<TimelineCell, Int> { (cell, indexPath, identifier) in
            let d = self.data[identifier]
            if d.isOverdue {
                cell.setAsPassed()
            }
            cell.setTitle(d.title)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: item)
        }
    }
    
    func registerHeaders() {
        let headerReg = UICollectionView.SupplementaryRegistration<TimelineCellToday>(elementKind: "header-element-kind") {
            (supplementaryView, string, indexPath) in
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerReg, for: index)
        }
    }
    
}

// MARK: - UI Delegate CollectionView

extension TimelineViewController: UICollectionViewDelegate {
    
}
