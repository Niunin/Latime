//
//  TimelineViewController.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import UIKit

// MARK: - Object

class TimelineViewController: UIViewController {
    
    var presenter: TimelinePresenterProtocol!
    private var collectionView: UICollectionView!
    
    
    // MARK: life cycle
    override func loadView() {
        let layout = makeLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view = collectionView
    }
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: 350 , height: 70)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        //layout.preferredLayoutAttributesFitting
        //layout.itemSize = CGSize(width: view.frame.size.width/2-12, height: view.frame.size.width/6-12)
        // layout.itemSize = CGSize(width: 100 , height: 20)
        return layout
    }
    
    override func viewDidLoad() {
        setupViews()
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TimelineCell.self, forCellWithReuseIdentifier: TimelineCell.reuseIdentifier)
        collectionView.register(TimelineCellToday.self, forCellWithReuseIdentifier: TimelineCellToday.reuseIdentifier)
        
    }
    
}

// MARK: - TimelineView Protocol

extension TimelineViewController: TimelineViewProtocol {
    
}

// MARK: - UICollectionView DataSource

extension TimelineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row  == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimelineCellToday.reuseIdentifier,
                                                          for: indexPath) as! TimelineCellToday
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimelineCell.reuseIdentifier, for: indexPath) as! TimelineCell
            return cell
        }
    }
    
}

// MARK: - UICollectionView Delegate

extension TimelineViewController: UICollectionViewDelegate {
    
}
