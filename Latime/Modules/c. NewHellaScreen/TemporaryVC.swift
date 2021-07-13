//
//  File.swift
//  Latime
//
//  Created by Andrei Niunin on 12.07.2021.
//

import UIKit


// MARK: - Object

class OrthogonalScrollBehaviorViewController: UIViewController {
    
    var currentSegment: Int? {
        didSet {
            guard  let n =  currentSegment else { return }
            scrollTo(n)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
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
}





// MARK: - Layout

extension OrthogonalScrollBehaviorViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: "header-element-kind",
            alignment: .top)
        
        let section0: NSCollectionLayoutSection = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1000))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = [header]
            return section
        }()
        
        let section1: NSCollectionLayoutSection = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1000))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
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
        
        let cellDateReg = UICollectionView.CellRegistration<DateCell, Int> { (cell, indexPath, identifier) in
        }
        
        let cellTextReg = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "Custom cell"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            if indexPath.section == 0, indexPath.row == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: cellDateReg, for: indexPath, item: identifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellTextReg, for: indexPath, item: identifier)
            }
        }
        
        let headerReg = UICollectionView.SupplementaryRegistration<TitleSegmentedView>(elementKind: "header-element-kind") {
            (supplementaryView, string, indexPath) in
            
            supplementaryView.delegate = self
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerReg, for: index)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems([0,1])
        snapshot.appendSections([1])
        snapshot.appendItems([2,3])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension OrthogonalScrollBehaviorViewController: TitleSegmentedDelegate {
    func currentSegment(_ segment: Int) {
        var ip = IndexPath(row: segment, section: 0)
        collectionView.scrollToItem(at: ip, at: .left, animated: true)
        return
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DateCell else {
            print("goddamn")
            return
        }
        if segment == 0 {
            cell.setAsMain(true)
        } else {
            cell.setAsMain(false)
        }
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

